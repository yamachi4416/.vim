inoremap <silent><expr><C-Space> g:VIMRC._.IMode("\<Down>", "\<C-Space>")
inoremap <silent><expr><C-S-Space> g:VIMRC._.IMode("\<Up>", "\<C-S-Space>")
inoremap <silent><expr><Tab> pumvisible() ? "\<C-y>" : "\<Tab>"

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

inoremap <silent> <C-b> <Left>
inoremap <silent> <C-f> <Right>
inoremap <silent> <C-p> <Up>
inoremap <silent> <C-n> <Down>

if exists('*wildmenumode')
  set wildmenu
  set wildcharm=<Tab>
  cnoremap <expr><Tab> wildmenumode() ? "\<C-n>" : "\<Tab>"
  cnoremap <expr><S-Tab> wildmenumode() ? "\<C-p>" : "\<S-Tab>"
endif

