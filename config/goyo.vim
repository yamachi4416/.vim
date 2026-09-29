let g:goyo_width='85%'
let g:goyo_height='100%'

let s:save = {}
let s:opts = {
\ 'cmdheight': 1,
\ 'showcmd': 0,
\ 'signcolumn': 'no',
\ 'conceallevel': 2,
\ 'concealcursor': 'nc',
\}

function! s:UpdateOpt(key, val) abort
  execute printf('let &%s = %s', a:key, string(a:val))
endfunction

function! s:GoyoEnter() abort
  for [l:key, l:val] in items(s:opts)
    let s:save[l:key] = eval('&' . l:key)
    call s:UpdateOpt(l:key, l:val)
  endfor
endfunction

function! s:GoyoLeave() abort
  for [l:key, l:val] in items(s:save)
    call s:UpdateOpt(l:key, l:val)
  endfor
  let s:save = {}
endfunction

augroup MyGoyo
  autocmd!
  autocmd User GoyoEnter nested call <SID>GoyoEnter()
  autocmd User GoyoLeave nested call <SID>GoyoLeave()
augroup END
