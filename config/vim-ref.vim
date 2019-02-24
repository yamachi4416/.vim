nmap K <plug>(ref-keyword)
let g:ref_cache_dir = expand('$VIMCACHEDIR/vim-ref')
let g:ref_source_webdict_sites = {
\   'wikipedia': {'url': 'https://ja.wikipedia.org/wiki/%s'},
\   'ejword': {
\     'url': 'http://dictionary.infoseek.ne.jp/ejword/%s',
\     'line': 19,
\   },
\ }

let g:ref_source_webdict_sites.default = 'wikipedia'

function! s:Webdict(mode, site)
  if a:mode == 'v'
    let tmp = @@
    silent! normal gvy
    let [word, @@] = [@@, tmp]
    silent! normal gv
  else
    let word = expand('<cword>')
  endif
  execute 'Ref webdict' a:site word
endfunction

nnoremap <silent> <C-K>j :<C-u>call <SID>Webdict('n', 'ejword')<CR>
vnoremap <silent> <C-K>j :<C-u>call <SID>Webdict('v', 'ejword')<CR>

let g:ref_refe_encoding = 'utf-8'
let g:ref_detect_filetype = get(g:, 'ref_detect_filetype', {})
