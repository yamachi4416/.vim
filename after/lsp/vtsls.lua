local mason_path = vim.fn.expand('$MASON/packages')
local vue_pugin_location = mason_path .. '/vue-language-server/node_modules/@vue/language-server'

--@type vim.lsp.Config
return {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = '@vue/typescript-plugin',
            location = vue_pugin_location,
            languages = { 'vue' },
            configNamespace = 'typescript',
          },
        },
      },
    },
  },
  filetypes = {
    'typescript',
    'typescriptreact',
    'vue',
  },
}
