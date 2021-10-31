inoremap <silent><expr><C-Space> g:VIMRC._.IMode("\<Down>", "\<C-Space>")
inoremap <silent><expr><C-S-Space> g:VIMRC._.IMode("\<Up>", "\<C-S-Space>")
inoremap <silent><expr><Tab> pumvisible() ? "\<C-y>" : "\<Tab>"

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

inoremap <silent> <C-b> <Left>
inoremap <silent> <C-f> <Right>

if exists('*wildmenumode')
  set wildmenu
  set wildcharm=<Tab>
  cnoremap <expr><Tab> wildmenumode() ? "\<C-n>" : "\<Tab>"
endif

