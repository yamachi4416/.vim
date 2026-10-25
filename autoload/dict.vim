function! s:DictLines(name) abort
  let l:config = get(get(g:, 'dict_config', {}), a:name, {})
  let l:path = get(l:config, 'path', '')
  if empty(l:path)
    throw printf('E:DictLines %s is not in g:dict_config', a:name)
  endif
  if !filereadable(l:path)
    throw printf('E:DictLines %s is not readable.', l:path)
  endif
  return readfile(l:path)
endfunction

function! s:DictFind(...) abort
  let l:name = get(a:000, 0, '')
  let l:word = tolower(get(a:000, 1, ''))
  let l:maxlength = get(a:000, 2, 5)

  let l:items = []
  let l:lines = s:DictLines(l:name)
  for l:line in l:lines
    let l:key = tolower(matchstr(l:line, '\v[^\t]+'))

    if l:key ==# l:word
      return [l:line]
    elseif stridx(l:key, l:word) ==# 0
      call add(l:items, l:line)
    endif

    if len(l:items) >= l:maxlength
      break
    endif
  endfor

  return l:items
endfunction

function! dict#find(...) abort
  let l:name = get(a:000, 0, '')
  let l:word = get(a:000, 1, '')

  if empty(l:word)
    let l:word = expand('<cword>')
  endif

  let l:items = s:DictFind(l:name, l:word, 5)
  if empty(l:items)
    echo printf('%s is not found in %s', l:word, l:name)
    return
  endif

  echo join(l:items, "\n")
endfunction
