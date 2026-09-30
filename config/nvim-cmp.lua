local cmp = require('cmp')

local sources = {
  { name = 'nvim_lsp' },
}

---@type {
--- expand: fun(body: string);
--- active: fun(dir: 1 | -1): boolean;
--- action: fun(dir: 1 | -1);
---}
local snippet = {
  expand = vim.snippet.expand,
  active = function(dir)
    return vim.snippet.active({ direction = dir })
  end,
  action = vim.snippet.jump,
}

if vim.fn.exists('g:loaded_vsnip') == 1 then
  sources[#sources + 1] = { name = 'vsnip' }

  snippet = {
    expand = vim.fn['vsnip#anonymous'],
    active = function(dir)
      local name = dir == 1 and 'vsnip#available' or 'vsnip#jumpable'
      return vim.fn[name](dir) == 1
    end,
    action = function(dir)
      local name = dir == 1 and 'vsnip-expand-or-jump' or 'vsnip-jump-prev'
      vim.api.nvim_feedkeys(vim.keycode('<Plug>(' .. name .. ')'), '', true)
    end
  }
end

cmp.setup({
  snippet = {
    expand = function(args)
      snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-e>']   = cmp.mapping.abort(),
    ['<CR>']    = cmp.mapping.confirm({ select = true }),
    ['<Tab>']   = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      elseif snippet.active(1) then
        snippet.action(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if snippet.active(-1) then
        snippet.action(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources(sources),
})
