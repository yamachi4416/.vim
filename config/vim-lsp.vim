function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete

  if !&l:diff
    if &l:filetype !=# 'vim'
      setlocal foldmethod=expr
      setlocal foldexpr=lsp#ui#vim#folding#foldexpr()
      setlocal foldtext=lsp#ui#vim#folding#foldtext()
    endif
  endif

  if exists(':sign')
    if &l:signcolumn !=# 'yes'
      setlocal signcolumn=yes
    endif
  endif

  if exists('+tagfunc')
    setlocal tagfunc=lsp#tagfunc
  endif

  nmap <buffer> <A-S-F> <plug>(lsp-document-format)
  vmap <buffer> <A-S-F> <plug>(lsp-document-range-format)
endfunction

augroup my_lsp_installed
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_echo_cursor = 1

