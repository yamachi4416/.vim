let s:_ = g:VIMRC._

function! s:OpenGitDiff()
  let hash = expand('<cword>')
  if hash =~# '^\v\w+$'
    call s:_.ScratchWindow(system('git show ' . hash))
    setlocal filetype=gitcommit
  endif
endfunction

nnoremap <buffer> <C-k> :<C-u>call <SID>OpenGitDiff()<CR>
