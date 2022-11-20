let s:_ = g:VIMRC._

nnoremenu &Edit.&Format(&EFM) :<c-u>LspDocumentFormatSync --server=efm-langserver<cr>
