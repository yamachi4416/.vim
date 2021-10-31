function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete

  if &l:filetype !=# 'vim'
    setlocal foldmethod=expr
    setlocal foldexpr=lsp#ui#vim#folding#foldexpr()
    setlocal foldtext=lsp#ui#vim#folding#foldtext()
  endif

  if exists(':sign')
    setlocal signcolumn=yes
  endif

  if exists('+tagfunc')
    setlocal tagfunc=lsp#tagfunc
  endif
endfunction

augroup my_lsp_installed
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

