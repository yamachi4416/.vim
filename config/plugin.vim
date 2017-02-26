let s:_ = g:VIMRC._
call s:_.SourceIfExists('$VIMRUNTIME/macros/matchit.vim')

if s:_.IsInstall('neosnippet')
  let g:neosnippet#data_directory = expand('$VIMCACHEDIR/neosnippet')
  let g:neosnippet#snippets_directory = expand('$MYVIMFILES/snippets')
  imap <C-k><C-l> <Plug>(neosnippet_expand_or_jump)
  smap <C-k><C-l> <Plug>(neosnippet_expand_or_jump)
  xmap <C-k><C-l> <Plug>(neosnippet_expand_target)
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
  function! g:VIMRC._AUTOCMDS_.CtrlpRubyRequire()
    au filetype ruby nnoremap <leader>i :<C-u>CtrlPRubyRequire<CR>
  endfunction
endif

if s:_.IsInstall('neco-ghc')
  function! g:VIMRC._AUTOCMDS_.Neco_GHC()
    au filetype haskell setlocal omnifunc=necoghc#omnifunc
  endfunction
endif

if s:_.IsInstall('vim-easy-align')
  xmap <leader>ga <Plug>(EasyAlign)
  nmap <leader>ga <Plug>(EasyAlign)
endif

" tern_for_vim
let g:tern_show_signature_in_pum = 1
let g:tern_show_argument_hints = 'on_hold'

" vim-tags
let g:vim_tags_auto_generate = 0
