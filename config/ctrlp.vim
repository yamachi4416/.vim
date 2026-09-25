let g:ctrlp_show_hidden = 0
let g:ctrlp_cache_dir = expand('$VIMCACHEDIR/ctrlp')
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
