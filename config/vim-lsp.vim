let g:lsp_async_completion = 1
let g:lsp_diagnostics_highlights_insert_mode_enabled = 0

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete

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

