let s:_ = g:VIMRC._
call s:_.SourceIfExists('$VIMRUNTIME/macros/matchit.vim')

if s:_.IsInstall('neosnippet')
  let g:neosnippet#data_directory = expand('$VIMCACHEDIR/neosnippet')
  let g:neosnippet#snippets_directory = expand('$MYVIMFILES/snippets')
  imap <C-k><C-l> <Plug>(neosnippet_expand_or_jump)
  smap <C-k><C-l> <Plug>(neosnippet_expand_or_jump)
  xmap <C-k><C-l> <Plug>(neosnippet_expand_target)
endif

if s:_.IsInstall('ctrlp-rubyrequire')
  function! g:VIMRC._AUTOCMDS_.CtrlpRubyRequire()
    au filetype ruby nnoremap <leader>i :<C-u>CtrlPRubyRequire<CR>
  endfunction
endif

" tern_for_vim
let g:tern_show_signature_in_pum = 1
let g:tern_show_argument_hints = 'on_hold'
