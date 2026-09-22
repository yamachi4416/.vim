require("mason").setup()
require("mason-lspconfig").setup {
  automatic_enable = {
    "lua_ls",
    "vimls"
  }
}
