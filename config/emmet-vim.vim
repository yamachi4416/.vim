let g:user_emmet_leader_key='<C-k>'
let g:emmet_html5 = 1
let g:user_emmet_settings = {
\ 'variables': { 'lang': 'ja' },
\ 'html': {
\   'aliases': {
\     's': 'span'
\   },
\   'empty_element_suffix': ' />',
\ }
\}

function! VIMRC._AUTOCMDS_.Emmet()
  au filetype html
  \  inoremap <silent><buffer> <C-Down> <esc>:call emmet#lang#html#moveNextPrev(0)<cr>
  \| inoremap <silent><buffer> <C-Up>   <esc>:call emmet#lang#html#moveNextPrev(1)<cr>
  \| nnoremap <silent><buffer> <C-Down> <esc>:call emmet#lang#html#moveNextPrev(0)<cr>
  \| nnoremap <silent><buffer> <C-Up>   <esc>:call emmet#lang#html#moveNextPrev(1)<cr>
endfunction
