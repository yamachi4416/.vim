let &t_SI .= "\<Esc>]50;CursorShape=1\x7"
let &t_EI .= "\<Esc>]50;CursorShape=0\x7"

imap <ESC>OA <UP>
imap <ESC>OD <Left>
imap <ESC>OC <Right>

imap <nowait><ESC> <ESC>
imap <C-@> <C-Space>
nnoremap <S-Tab> gt

augroup localrc
  au!
  au Bufread ~/.rbenv/**/* setl readonly
augroup END

set belloff=all

call g:VIMRC._.SourceIfExists('_localrc.vim')
