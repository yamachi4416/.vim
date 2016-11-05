let &t_SI .= "\<Esc>]50;CursorShape=1\x7"
let &t_EI .= "\<Esc>]50;CursorShape=0\x7"

imap OA <UP>
imap <nowait><ESC> <ESC>
imap <C-@> <C-Space>
nnoremap <S-Tab> gt

augroup localrc
  au!
  au Bufread ~/.rbenv/**/* setl readonly
augroup END

set belloff=all
set termguicolors
set background=dark

try
  colorscheme iceberg
catch /.*/
  colorscheme delek
endtry
