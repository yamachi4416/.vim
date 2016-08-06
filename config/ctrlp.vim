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

nmap <leader>c [CtrlP]
nmap [CtrlP] <NOP>
nnoremap [CtrlP]c :<C-u>CtrlPQuickfix<CR>
nnoremap <leader>ct :<C-u>CtrlPBufTagAll<CR>
nnoremap <leader>cb :<C-u>CtrlPBuffer<CR>
nnoremap <leader>cl :<C-u>CtrlPLine<CR>
nnoremap <leader>cx :<C-u>CtrlPClearCache<CR>
nnoremap <leader>c<Space> :<C-u>CtrlPCurFile<CR>

if has('python3') || has('python')
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif
