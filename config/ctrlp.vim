let g:ctrlp_show_hidden = 0
let g:ctrlp_cache_dir = expand('$VIMCACHEDIR') . '/ctrlp'
let g:ctrlp_user_command = {
\ 'types': {
\   1: ['.git', 'cd %s && git ls-files -co --exclude-standard'],
\ },
\}

if executable('rg')
  let g:ctrlp_user_command.fallback = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif
