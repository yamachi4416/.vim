let g:lsp_settings = {
\ 'efm-langserver': {
\   'disabled': v:false,
\   'args': ['-c', expand('$MYVIMFILES/config/efm-langserver/config.yaml')]
\ },
\ 'vscode-eslint-language-server': {
\   'allowlist': [
\     'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue'
\   ],
\ },
\}

let g:lsp_settings_filetype_typescript = [
\ 'typescript-language-server',
\ 'vscode-eslint-language-server'
\]

let g:lsp_settings_filetype_vue = [
\ 'vtsls',
\ 'volar-server',
\ 'vscode-eslint-language-server'
\]

let g:lsp_settings_filetype_rust = [
\ 'rust-analyzer',
\ 'bacon-ls'
\]

