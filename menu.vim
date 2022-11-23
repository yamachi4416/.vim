let s:_ = g:VIMRC._

nnoremenu &Lsp.&Format :<c-u>LspDocumentFormat<cr>
nnoremenu &Lsp.&Format(&SYN) :<c-u>LspDocumentFormatSync<cr>
nnoremenu &Lsp.&Format(&EFM) :<c-u>LspDocumentFormatSync --server=efm-langserver<cr>
nnoremenu &Lsp.&Diagnostic(&EFM) :<c-u>LspDocumentDiagnostic --server=efm-langserver<cr>
