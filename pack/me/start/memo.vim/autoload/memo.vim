let s:expand = function('vimrc#util#expand')

function! s:getMemoDir() abort
  let l:dir = get(g:, 'memo_dir', '')
  if empty(l:dir)
    throw 'E:MemoDir g:memo_dir is empty'
  endif
  let l:dir = s:expand(l:dir)
  if !isdirectory(l:dir)
    throw 'E:MemoDir g:memo_dir is not a directory'
  endif
  return l:dir
endfunction

function! s:getOrInput(value, prompt) abort
  let l:value = trim(a:value)
  if !empty(l:value)
    return l:value
  endif
  return trim(input(a:prompt, ''))
endfunction

function! memo#new(title) abort
  let l:dir = s:getMemoDir()
  let l:title = s:getOrInput(a:title, 'Title: ')
  if empty(l:title) | return | endif
  let l:name = substitute(l:title, '\v([/\\:*?"<>|]|\s)+', '_', 'g')
  let l:path = printf('%s/%s_%s.md', l:dir, strftime('%Y%m%d'), l:name)
  let l:path = substitute(l:path, '\v[\\/]+', '/', 'g')
  split `=l:path`
  if !filereadable(l:path)
    call setline(1, printf('# %s', l:title))
  endif
endfunction

function! memo#find(search) abort
  let l:dir = s:getMemoDir()
  let l:search = s:getOrInput(a:search, 'Search: ')
  if empty(l:search) | return | endif
  execute printf('grep %s %s', shellescape(l:search), fnameescape(l:dir))
endfunction
