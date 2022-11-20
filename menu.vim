let s:_ = g:VIMRC._

nnoremenu &Lsp.&Format(&EFM) :<c-u>LspDocumentFormatSync --server=efm-langserver<cr>
nnoremenu &Lsp.&Diagnostic(&EFM) :<c-u>LspDocumentDiagnostic --server=efm-langserver<cr>
