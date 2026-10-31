function! s:getConfig(name) abort
  let l:config = get(get(g:, 'kwdict', {}), a:name)
  if type(l:config) !=# type({})
    throw printf('E:kwdict cannot get %s config.', a:name)
  endif
  return extend({
  \ 'path': '',
  \ 'iskeyword': '',
  \ 'threshold': 2,
  \}, l:config)
endfunction

function! s:getLines(path) abort
  if !filereadable(a:path)
    throw printf('E:kwdict %s is not readable.', l:path)
  endif
  return readfile(a:path)
endfunction

function! s:getCword(iskeyword) abort
  if empty(a:iskeyword)
    return expand('<cword>')
  endif
  try
    let l:save = &l:iskeyword
    let &l:iskeyword = a:iskeyword
    return expand('<cword>')
  finally
    let &l:iskeyword = l:save
  endtry
endfunction

function! s:find(config, word) abort
  let l:path = get(a:config, 'path', '')
  let l:threshold = get(a:config, 'threshold', 2)
  let l:word = tolower(a:word)
  let l:max_score = 0

  let l:items = []
  for l:line in s:getLines(l:path)
    let l:key = tolower(matchstr(l:line, '\v[^\t]+'))

    if l:key ==# l:word
      return [l:line]
    else
      let l:last = min([strchars(l:key), strchars(l:word)])
      let l:score = 0
      while l:score < l:last && strgetchar(l:key, l:score) ==# strgetchar(l:word, l:score)
        let l:score += 1
      endwhile
      if l:score >= l:threshold && l:max_score <= l:score
        let l:max_score = l:score
        call add(l:items, [l:score, l:line])
      endif
    endif
  endfor

  let l:lines = []
  for l:item in l:items
    if l:item[0] ==# l:max_score
      call add(l:lines, l:item[1])
    endif
  endfor

  return l:lines
endfunction

function! kwdict#find(...) abort
  let l:name = get(a:000, 0, '')
  let l:word = get(a:000, 1, '')
  let l:config = s:getConfig(l:name)

  if empty(l:word)
    let l:word = s:getCword(l:config.iskeyword)
  endif

  let l:items = s:find(l:config, l:word)
  if empty(l:items)
    echo printf('%s is not found in %s', l:word, l:name)
    return
  endif

  echo join(map(l:items, {_, v -> substitute(v, '\t', "\n\t", 'g')}), "\n")
endfunction
