--@type vim.lsp.Config
return {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = '@vue/typescript-plugin',
            location = vim.fs.joinpath(
              vim.fn.expand('$MASON'),
              '/packages/vue-language-server/node_modules/@vue/language-server'
            ),
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
