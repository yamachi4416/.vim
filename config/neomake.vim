let g:neomake_error_sign   = {'text': '>>', 'texthl': 'ErrorMsg'}
let g:neomake_warning_sign = {'text': '>>', 'texthl': 'WarningMsg'}
let g:neomake_message_sign = {'text': '~', 'texthl': 'MoreMsg' }
let g:neomake_info_sign    = {'text': '~', 'texthl': 'ModeMsg'}
let g:neomake_open_list = 0
let g:neomake_list_height = 5
augroup neomake_buffer_post
  autocmd!
  autocmd bufwritepost * Neomake
augroup END
