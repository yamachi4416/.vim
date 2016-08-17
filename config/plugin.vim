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

if s:_.IsInstall('jscomplete-vim')
  let g:jscomplete_use = ['dom', 'html5API', 'webGL']
  let g:jscomplete_webgl_ns = ['gl', 'webgl']
  "let g:VIMRC.Omni.javascript = 'jscomplete#CompleteJS'
endif

if s:_.IsInstall('tern_for_vim') && (has('python3') || has('python'))
  "let &rtp = join(filter(split(&rtp, ','), 'v:val !~# ''tern_for_vim.after'''), ',')
  let g:tern_show_signature_in_pum = 1
  let g:tern_show_argument_hints = 'on_hold'

  "function! s:TernEnable()
  "  let package_json = findfile('package.json', expand(expand('%:p:h').'/;'))
  "  if package_json !=# ''
  "    call tern#Enable()
  "    setl omnifunc=tern#Complete
  "  endif
  "endfunction

  "function! VIMRC._AUTOCMDS_.TernEnable()
  " au filetype javascript call s:TernEnable()
  "endfunction
endif

if s:_.IsInstall('tagbar')
  nnoremap <F8> :<C-u>TagbarToggle<CR>
  let g:tagbar_autofocus = 1
  let g:tagbar_iconchars = ['+', '-']
endif

if s:_.IsInstall('syntastic')
  let g:syntastic_aggregate_errors = 1
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 2
  let g:syntastic_loc_list_height = 4
endif

if s:_.IsInstall('nerdtree')
  if s:_.IsInstall('vim-nerdtree-tabs')
    nnoremap <F10> :<C-u>NERDTreeTabsToggle<CR>
  else
    nnoremap <F10> :<C-u>NERDTreeToggle<CR>
  endif
endif

if s:_.IsInstall('lexima.vim')
  call lexima#init()
  inoremap <expr><CR> pumvisible() ? "\<C-e><CR>" : lexima#expand('<LT>CR>', 'i')
endif

if s:_.IsInstall('ctrlp-rubyrequire')
  function! VIMRC._AUTOCMDS_.CtrlpRubyRequire()
    au filetype ruby nnoremap <leader>i :<C-u>CtrlPRubyRequire<CR>
  endfunction
endif
