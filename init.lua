vim.cmd.source(vim.fs.joinpath(vim.fn.expand('<script>:p:h'), 'vimrc'))

local function format()
  if vim.fn.exists(':LspEslintFixAll') == 2 then
    vim.cmd('LspEslintFixAll')
  end
  vim.lsp.buf.format()
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = 'Vimrc',
  callback = function(args)
    vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })

    vim.keymap.set('n', '<leader>w', vim.diagnostic.setloclist, { buf = args.buf })
    vim.keymap.set('n', '<leader>f', format, { buf = args.buf })
    vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, { buf = args.buf })

    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = args.buf,
      callback = format,
    })
  end,
})
