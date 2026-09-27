function! vimrc#util#splitln(str) abort
  return split(a:str, '\v\r\n|\n|\r')
endfunction

function! vimrc#util#winsplit(cmd, name) abort
  let l:wincmd = (winwidth(0) * 1.0 / winheight(0) <= 4.0 ? '' : 'vert ') . a:cmd
  if empty(a:name)
    execute l:wincmd
  else
    execute printf('%s %s', a:cmd, fnameescape(a:name))
  endif
endfunction

function! vimrc#util#imode(...) abort
  if pumvisible()
    return get(a:000, 0, '')
  elseif &l:omnifunc !=# ''
    return "\<C-x>\<C-o>"
  elseif !empty(tagfiles())
    return "\<C-x>\<C-]>"
  endif
  return "\<C-p>"
endfunction

function! vimrc#util#scratch_window_with_name(name, args) abort
  call vimrc#util#winsplit('new', a:name)
  setlocal buftype=nofile bufhidden=wipe noswapfile
  if len(a:args)
    let l:arg = a:args[0]
    if type(l:arg) is type('')
      call append(line('$') - 1, vimrc#util#splitln(l:arg))
    elseif type(l:arg) is type([])
      call append(line('$') - 1, l:arg)
    endif
  endif
  keepjumps normal! gg
  nnoremap <buffer><silent><C-l> :<C-u>%d _ <Bar>redraw<CR>
endfunction

function! vimrc#util#scratch_window(...) abort
  call vimrc#util#scratch_window_with_name('', a:000)
endfunction

function! vimrc#util#includeexpr(fname) abort
  let l:suff = &l:suffixesadd
  let l:file = fnamemodify(a:fname, ':e') ==# '' ? a:fname . suff : a:fname
  let l:base = join(add(split(&l:path, ','), get(b:, 'base_path', '')), ',')
  let l:ret = globpath(l:base, l:file, 0, 1)
  if len(l:ret) == 0
    let l:ret = glob('./**/' . l:file)
  else
    let l:ret += [l:file]
  endif
  return filereadable(l:ret[0]) ? l:ret[0] : v:fname
endfunction

function! vimrc#util#get_file_from_url(url, file) abort
  if executable('powershell') || executable('pwsh')
    let l:powershell = executable('pwsh') ? 'pwsh' : 'powershell'
    let l:powershell .= ' -NoLog -NoProfile -ExecutionPolicy RemoteSigned -Command '
    let l:command = '(New-Object System.Net.WebClient).DownloadFile(''%s'', ''%s'')'
    call system(l:powershell . shellescape(printf(l:command, a:url, a:file)))
  elseif executable('curl')
    let l:command = 'curl -fLo %s %s'
    call system(printf(l:command, shellescape(a:file), a:url))
  endif
endfunction

function! vimrc#util#expand(path) abort
  let l:wildignore = &wildignore
  try
    set wildignore=
    return expand(a:path)
  finally
    let &wildignore = l:wildignore
  endtry
endfunction

function! vimrc#util#fname_part(path) abort
  let l:fname = matchstr(a:path, '\v[\/]\zs[^\/]+$')
  let l:ext = get(split(l:fname, '\v\ze\.'), -1, '')
  let l:name = slice(l:fname, 0, len(l:fname) - len(l:ext))
  return { 'path': a:path, 'fname': l:fname, 'name': l:name, 'ext': l:ext }
endfunction

function! vimrc#util#source(path) abort
  let l:file = vimrc#util#fname_part(vimrc#util#expand(a:path))
  if !has('nvim') && l:file.ext !=# '.vim'
    return 0
  endif
  if filereadable(l:file.path)
    source `=l:file.path`
    return 1
  endif
  return 0
endfunction

function! vimrc#util#get_select_text() abort
  let l:save = @@
  silent normal! gvy
  let [l:ret, @@] = [@@, l:save]
  return l:ret
endfunction

function! vimrc#util#is_installed(name) abort
  if exists('g:plugs')
    return has_key(g:plugs, a:name) ||
    \ has_key(g:plugs, a:name . '.vim') ||
    \ has_key(g:plugs, a:name . '.nvim')
  endif
  return &runtimepath =~# '\v[\\/]' . a:name . ',?'
endfunction

