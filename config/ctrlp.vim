let g:ctrlp_regexp = 0
let g:ctrlp_reuse_window = 'unite\|vimshell\|netrw\|help\|quickfix'
let g:ctrlp_use_caching = 1
let g:ctrlp_cache_dir = expand('$VIMCACHEDIR/ctrlp')
let g:ctrlp_mruf_max = 50
let g:ctrlp_mruf_save_on_update = 1
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_max_files = 1000
let g:ctrlp_custom_ignore = {
\ 'dir':  '\v[\/](\.git|img|images?|imgs?|vendor)$',
\ 'file': '\v\.(exe|so|o|dll|class|jar|gz|tar|zip|cache)$'
\ }
nnoremap <F3> :<C-u>CtrlPBookmarkDir<CR>
