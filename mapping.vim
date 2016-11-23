nnoremap <silent><leader><F2> :<C-u>call g:VIMRC._.CreateDictUseSyntax()<CR>

map  <silent><F1> <ESC>:<C-u>nohlsearch<CR>
map! <silent><F1> <ESC>:<C-u>nohlsearch<CR>

inoremap <silent><expr><C-Space> g:VIMRC._.IMode("\<Down>", "\<C-Space>")
inoremap <silent><expr><C-S-Space> g:VIMRC._.IMode("\<Up>", "\<C-S-Space>")
inoremap <silent><expr><Tab> pumvisible() ? "\<C-y>" : "\<Tab>"

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

nnoremap <S-Tab> gt

if exists('*wildmenumode')
  set wildmenu
  set wildcharm=<Tab>
  cnoremap <expr><Tab> wildmenumode() ? "\<C-n>" : "\<Tab>"
endif
