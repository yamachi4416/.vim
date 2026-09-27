function! s:OpenGitDiff()
  let hash = expand('<cword>')
  if hash =~# '^\v\w+$'
    call vimrc#util#scratch_window(system('git show ' . hash))
    setlocal filetype=gitcommit
  endif
endfunction

nnoremap <buffer> <C-k> :<C-u>call <SID>OpenGitDiff()<CR>
