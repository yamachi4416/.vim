nnoremap <silent><F12> :<C-u>call VIMRC._.CreateDictUseSyntax()<CR>

map  <silent><F1> <ESC>:<C-u>nohlsearch<CR>
map! <silent><F1> <ESC>:<C-u>nohlsearch<CR>

nnoremap <silent><leader><CR> :<C-u>if glob('%') !=# ''<bar>lcd %:h<bar>endif<CR>
nnoremap <silent>{ :<C-u>keepjumps normal! {<CR>
nnoremap <silent>} :<C-u>keepjumps normal! }<CR>

inoremap <C-s> <C-o>:up<CR>

inoremap <silent><expr><C-Space> VIMRC._.IMode("\<Down>", "\<C-Space>")
inoremap <silent><expr><C-S-Space> VIMRC._.IMode("\<Up>", "\<C-S-Space>")
inoremap <silent><expr><Tab> pumvisible() ? "\<C-y>" : "\<Tab>"

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

nnoremap <C-s> :<C-u>up<CR>
inoremap <expr><C-s> pumvisible() ? '' : "\<C-o>:<C-u>up\<CR>"

if exists('*wildmenumode')
  set wildmenu
  set wildcharm=<Tab>
  cnoremap <expr><Tab> wildmenumode() ? "\<C-n>" : "\<Tab>"
endif

finish

" Note: xterm
imap <Nul> <C-Space>
