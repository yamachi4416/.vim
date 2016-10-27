let s:_ = g:VIMRC._
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
  let g:neocomplete#force_omni_input_patterns.cs = '[^.]\.\%(\u\{2,}\)\?'
  let g:neocomplete#force_omni_input_patterns.coffee = '[^.]\.\%(\u\{2,}\)\?'

  function! g:VIMRC._AUTOCMDS_.Neocomplete()
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

if s:_.IsInstall('neomake')
  let g:neomake_error_sign   = {'text': '>>', 'texthl': 'ErrorMsg'}
  let g:neomake_warning_sign = {'text': '>>', 'texthl': 'WarningMsg'}
  let g:neomake_message_sign = {'text': '~', 'texthl': 'MoreMsg' }
  let g:neomake_info_sign    = {'text': '~', 'texthl': 'ModeMsg'}
  let g:neomake_open_list = 1
  let g:neomake_list_height = 5
  augroup neomake_buffer_post
    autocmd!
    autocmd bufwritepost * Neomake
  augroup END
endif

" tern_for_vim
let g:tern_show_signature_in_pum = 1
let g:tern_show_argument_hints = 'on_hold'

" vim-tags
let g:vim_tags_auto_generate = 0
