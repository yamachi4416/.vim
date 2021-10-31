let g:ctrlp_map = '<Nop>'
let g:ctrlp_regexp = 0
let g:ctrlp_reuse_window = '\|netrw\|help\|quickfix'
let g:ctrlp_use_caching = 0
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_cache_dir = expand('$VIMCACHEDIR/ctrlp')
let g:ctrlp_mruf_max = 50
let g:ctrlp_mruf_save_on_update = 1
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_max_files = 1000
let g:ctrlp_custom_ignore = {
\ 'dir':  '\v[\/](\.git|img|images?|imgs?|vendor)$',
\ 'file': '\v\.(exe|so|o|dll|class|jar|gz|tar|zip|cache)$'
\ }

nnoremap <leader><leader> :<C-u>CtrlP
nmap <leader>c [CtrlP]
nmap [CtrlP] <NOP>
nnoremap [CtrlP]q :<C-u>CtrlPQuickfix<CR>
nnoremap [CtrlP]t :<C-u>CtrlPBufTagAll<CR>
nnoremap [CtrlP]b :<C-u>CtrlPBuffer<CR>
nnoremap [CtrlP]l :<C-u>CtrlPLine<CR>
nnoremap [CtrlP]d :<C-u>CtrlPClearCache<CR>
nnoremap [CtrlP]m :<C-u>CtrlPMRUFiles<CR>
nnoremap [CtrlP]f :<C-u>CtrlPCurFile<CR>
nnoremap [CtrlP]c :<C-u>CtrlPCurWD<CR>

