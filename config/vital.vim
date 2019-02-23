let g:loaded_vitalizer = 1
let s:_V = {}
let s:_ = g:VIMRC._

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

function! s:_.Hdata(...) abort
  let url = a:0 >= 1 ? a:1 : expand('<cfile>')
  let resp = s:V('Web.HTTP').request('GET', url, {
  \ 'headers': {'TE': ''}
  \ })
  let resp.header = s:V('Web.HTTP').parseHeader(resp.header)
  let type = get(resp.header, 'Content-Type', '')
  let char = tr(matchstr(type, '\v\ccharset\=\zs[a-z0-9\-_]+$'), '_', '-')
  let cnte = has_key(resp, 'content') ? remove(resp, 'content') : ''
  return &encoding != char ? iconv(cnte, char, &encoding) : cnte
endfunction

command! -nargs=1 HFile call s:_.ScratchWindow(s:_.Hdata(<q-args>))
command! -nargs=? -bang -complete=file Open call s:V('System.File').open(empty(<q-args>) ? expand('%') : <q-args> )
