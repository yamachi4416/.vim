nmap K <plug>(ref-keyword)
let g:ref_cache_dir = expand('$VIMCACHEDIR/vim-ref')
let g:ref_source_webdict_sites = {
\   'wikipedia': {'url': 'http://ja.wikipedia.org/wiki/%s'}
\ , 'it':   {'url': 'http://www.sophia-it.com/content/%s'}
\ , 'alc': {
\     'url': 'http://eow.alc.co.jp/%s/UTF-8/',
\     'line': 37,
\   }
\ }

let g:ref_source_webdict_sites.default = 'wikipedia'
let g:ref_javadoc_cmd = 'lynx -dump -nonumbers %s'
let g:ref_javadoc_path = expand('$REFSDIR/java/doc')

let g:ref_refe_encoding = 'utf-8'
let g:ref_detect_filetype = get(g:, 'ref_detect_filetype', {})
let g:ref_detect_filetype['ruby'] = 'ri'
