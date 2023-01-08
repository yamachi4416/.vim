let g:lsp_async_completion = 1
let g:lsp_fold_enabled = 1
let g:lsp_document_highlight_enabled = 0
"let g:lsp_use_native_client = 1

let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 0
let g:lsp_diagnostics_signs_enabled = 1
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_highlights_insert_mode_enabled = 1
let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 0

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

