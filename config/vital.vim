let g:loaded_vitalizer = 1
let s:_V = {}
let s:_ = g:VIMRC._
let s:USER_AGENT = 'Mozilla/5.0 (Windows NT 6.3; WOW64; rv:42.0) Gecko/20100101 Firefox/42.0'

function! s:V(ns)
  if !has_key(s:_V, a:ns)
    let s:_V[a:ns] = vital#of('vital').import(a:ns)
  endif
  return s:_V[a:ns]
endfunction

function! s:encodeURI(str) abort
  return s:V('Web.HTTP').encodeURI(a:str)
endfunction

function! s:decodeHTMLEntities(str) abort
  let ete = {
  \   '&gt;'   : '>', '&lt;'  : '<', '&quot;'  : '"',
  \   '&#160;' : ' ', '&#39;' : "'", '&#8203;' : '', '&#12316;' : '~',}
  let ret = substitute(a:str, '\v\&[a-z#0-9]{2,};', '\=get(ete, submatch(0), submatch(0))', 'g')
  return substitute(ret, '&amp;', '\&', 'g')
endfunction

" command! E0 J0 (GoogleTranslate)
function! s:_.GoogleHonyaku(text, sl, tl) abort
  if a:text ==# '' | return '' | endif
  let text = substitute(a:text, '\v(\r|\n)$', '', 'g')
  let url = printf('https://translate.google.com?sl=%s&tl=%s&ie=%s&oe=%s&text=%s',
  \ a:sl, a:tl, &encoding, &encoding, s:encodeURI(text))
  let ret = matchstr(s:_.Hdata(url), '\v\CTRANSLATED_TEXT\=''\zs[^'']+\ze''')
  let ret = substitute(ret, '\v\\x(\x\x)','\=nr2char(str2nr(submatch(1), 16))', 'g')
  return join(split(s:decodeHTMLEntities(ret), '\V<br>'), "\n")
endfunction

function! s:_.HonyakuAndEcho(bang, txt, sl, tl) abort
  let txt = a:txt =~# '\v^\s*$' ? s:_.GetSelectText() : a:bang ? eval(a:txt) : a:txt
  echo s:_.GoogleHonyaku(txt, a:sl, a:tl)
endfunction

function! s:_.Hdata(...) abort
  let url = a:0 >= 1 ? a:1 : expand('<cfile>')
  let resp = s:V('Web.HTTP').request('GET', url, {
  \ 'headers': {'TE': '', 'User-Agent': s:USER_AGENT }
  \ })
  let resp.header = s:V('Web.HTTP').parseHeader(resp.header)
  let type = get(resp.header, 'Content-Type', '')
  let char = tr(matchstr(type, '\v\ccharset\=\zs[a-z0-9\-_]+$'), '_', '-')
  let cnte = has_key(resp, 'content') ? remove(resp, 'content') : ''
  return &encoding != char ? iconv(cnte, char, &encoding) : cnte
endfunction

command! -nargs=* -bang -range E0 cal s:_.HonyakuAndEcho(<bang>0, <q-args>, 'en', 'ja')
command! -nargs=* -bang -range J0 cal s:_.HonyakuAndEcho(<bang>0, <q-args>, 'ja', 'en')
vnoremap <silent><leader>e :<C-u>E0<CR>
nnoremap <silent><leader>e :<C-u>execute 'E0' expand('<cword>')<CR>


command! -nargs=1 HFile call s:_.ScratchWindow(s:_.Hdata(<q-args>))
command! -nargs=? -bang -complete=file Open call s:V('System.File').open(empty(<q-args>) ? expand('%') : <q-args> )
