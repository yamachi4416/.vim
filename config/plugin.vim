let s:_ = VIMRC._
call s:_.SourceIfExists('$VIMRUNTIME/macros/matchit.vim')

if s:_.IsInstall('neocomplete')
  let g:neocomplete#data_directory = expand('$VIMCACHEDIR/neocomplete')
  let g:neocomplete#enable_fuzzy_completion = 1
  let g:neocomplete#enable_auto_select = 1
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_auto_delimiter = 1

  call neocomplete#custom#source('tag', 'disabled_filetypes', {'_': 1})
  call neocomplete#custom#source('include', 'disabled_filetypes', {'_': 1})

  let g:neocomplete#force_omni_input_patterns =
  \ get(g:, 'neocomplete#force_omni_input_patterns', {})
  let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

  function! VIMRC._AUTOCMDS_.Neocomplete()
    au filetype ruby NeoCompleteLock
  endfunction
endif

if s:_.IsInstall('neosnippet')
  let g:neosnippet#data_directory = expand('$VIMCACHEDIR/neosnippet')
  let g:neosnippet#snippets_directory = expand('$MYVIMFILES/snippets')
  imap <C-k><C-l> <Plug>(neosnippet_expand_or_jump)
  smap <C-k><C-l> <Plug>(neosnippet_expand_or_jump)
  xmap <C-k><C-l> <Plug>(neosnippet_expand_target)
endif

if s:_.IsInstall('caw.vim')
  let g:caw_no_default_keymappings = 1
  nmap gct <Plug>(caw:I:toggle)
  vmap gct <Plug>(caw:I:toggle)
endif

if s:_.IsInstall('vim-asterisk')
  map * <Plug>(asterisk-*)
  map # <Plug>(asterisk-#)
endif

if s:_.IsInstall('tagbar')
  nnoremap <F8> :<C-u>TagbarToggle<CR>
  let g:tagbar_autofocus = 1
  let g:tagbar_iconchars = ['+', '-']
endif

if s:_.IsInstall('nerdtree')
  if s:_.IsInstall('vim-nerdtree-tabs')
    nnoremap <F10> :<C-u>NERDTreeTabsToggle<CR>
  else
    nnoremap <F10> :<C-u>NERDTreeToggle<CR>
  endif
endif

if s:_.IsInstall('ctrlp-rubyrequire')
  function! VIMRC._AUTOCMDS_.CtrlpRubyRequire()
    au filetype ruby nnoremap <leader>i :<C-u>CtrlPRubyRequire<CR>
  endfunction
endif

if s:_.IsInstall('neco-ghc')
  function! VIMRC._AUTOCMDS_.Neco_GHC()
    au filetype haskell setlocal omnifunc=necoghc#omnifunc
  endfunction
endif

" tern_for_vim
let g:tern_show_signature_in_pum = 1
let g:tern_show_argument_hints = 'on_hold'

" syntastic
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_loc_list_height = 4

" vim-tags
let g:vim_tags_auto_generate = 0
