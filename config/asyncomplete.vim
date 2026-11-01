inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() . "\<CR>" : "\<CR>"
imap <C-Space> <Plug>(asyncomplete_force_refresh)
