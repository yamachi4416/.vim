nmap K <plug>(ref-keyword)
let g:ref_cache_dir = expand('$VIMCACHEDIR/vim-ref')
let g:ref_source_webdict_sites = {
\   'wikipedia': {'url': 'https://ja.wikipedia.org/wiki/%s'}
\   'ej': {
\     'url': 'http://dictionary.infoseek.ne.jp/ejword/%s',
\     'line': 19,
\   },
\ }

let g:ref_source_webdict_sites.default = 'wikipedia'

let g:ref_refe_encoding = 'utf-8'
let g:ref_detect_filetype = get(g:, 'ref_detect_filetype', {})

nnoremap <silent> <C-K>j :<C-u>Ref webdict ej <C-r>=expand('<cword>')<CR><CR>
