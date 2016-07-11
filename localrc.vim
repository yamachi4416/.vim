set novisualbell
set background=dark

colorscheme jellybeans

let &t_SI .= "\<Esc>]50;CursorShape=1\x7"
let &t_EI .= "\<Esc>]50;CursorShape=0\x7"

imap OA <UP>
imap <nowait><ESC> <ESC>
imap <C-@> <C-Space>

augroup localrc
  au!
  au Bufread ~/.rbenv/**/* setl readonly
augroup END
