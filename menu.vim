let s:_ = g:VIMRC._

function! s:BuildCommand(cmd, opts, sep) abort
  let l:cmdline = a:cmd
  for l:key in keys(a:opts)
    let l:val = a:opts[l:key]
    let l:cmdline = l:cmdline . ' ' . l:key . a:sep . shellescape(l:val)
  endfor
  return l:cmdline
endfunction

function! s:GitLogGraph() abort
  let l:cmdline = s:BuildCommand(
  \'git log --oneline --graph --all', {
  \ '--date': 'short',
  \ '--decorate': 'full',
  \ '--format': "%h\t%ad\t%d\t%s",
  \}, '=')
  let l:out = systemlist(l:cmdline)
  call s:_.ScratchWindow(l:out)
  setlocal filetype=gitrebase
endfunction

nnoremenu <silent> &Lsp.&Format :<c-u>LspDocumentFormat<cr>
nnoremenu <silent> &Lsp.&Format(&SYN) :<c-u>LspDocumentFormatSync<cr>
nnoremenu <silent> &Lsp.&Format(&EFM) :<c-u>LspDocumentFormatSync --server=efm-langserver<cr>
nnoremenu <silent> &Lsp.&Diagnostic(&EFM) :<c-u>LspDocumentDiagnostic --server=efm-langserver<cr>

nnoremenu <silent> &Git.&Log(&Graph) :<c-u>call <sid>GitLogGraph()<cr>

