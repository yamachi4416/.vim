let s:_ = g:VIMRC._

function! s:SystemOut(cmd, filetype)
  let l:out = system(a:cmd)
  call s:_.ScratchWindow(l:out)
  let &l:filetype = a:filetype
endfunction

function! s:GitLogGraph()
  let l:cmd = "git log --oneline --graph --all --date=short --decorate=short --format='%h\t%ad\t%d\t%s'"
  let l:out = systemlist(l:cmd)
  call s:_.ScratchWindow(l:out)
  setlocal filetype=gitrebase
endfunction

nnoremenu <silent> &Lsp.&Format :<c-u>LspDocumentFormat<cr>
nnoremenu <silent> &Lsp.&Format(&SYN) :<c-u>LspDocumentFormatSync<cr>
nnoremenu <silent> &Lsp.&Format(&EFM) :<c-u>LspDocumentFormatSync --server=efm-langserver<cr>
nnoremenu <silent> &Lsp.&Diagnostic(&EFM) :<c-u>LspDocumentDiagnostic --server=efm-langserver<cr>

nnoremenu <silent> &Git.&Log(&Graph) :<c-u>call <sid>GitLogGraph()<cr>

