let g:lsp_settings = {
\ 'efm-langserver': {
\   'disabled': v:false,
\   'args': ['-c', expand('$MYVIMFILES/config/efm-langserver/config.yaml')]
\ },
\}
let g:lsp_settings_filetype_typescript = ['typescript-language-server', 'eslint-language-server']
