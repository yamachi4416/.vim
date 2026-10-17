function! s:BuildCommand(cmd, opts, sep) abort
  let l:cmdline = a:cmd
  for l:key in keys(a:opts)
    let l:val = a:opts[l:key]
    let l:cmdline = l:cmdline . ' ' . l:key . a:sep . shellescape(l:val)
  endfor
  return l:cmdline
endfunction

function! s:CreateDictUseSyntax() abort
  if &l:syntax ==# '' || &l:syntax ==# 'text'
    return
  endif

  let l:file = $MYVIMDIR . '/.local/dict/' . &l:syntax . '.txt'
  if !filereadable(l:file)
    let l:words = {}
    for l:word in syntaxcomplete#OmniSyntaxList()
      let l:words[l:word] = 0
    endfor
    if writefile(sort(keys(l:words)), l:file) == -1
      echoh ErrorMsg | echom 'Error' | echoh Normal | return
    endif
  endif

  tabe `=l:file`
  nnoremap <buffer><silent><F12> :<C-u>silent keeppatterns g/\v^.?$/d<CR>:%sort u<CR>:wq<CR>
endfunction
command! -nargs=? CreateDictUseSyntax call s:CreateDictUseSyntax()

command! -nargs=? -bang -complete=function
\ ScratchWindow call vimrc#util#scratch_window(<bang>0 ? eval(<q-args>) : <q-args>)

function! s:ShellOutput(range, cmd) abort
  let l:cmd = a:cmd

  if a:range
    if empty(l:cmd)
      let l:cmd = get(matchlist(getline(1), '\v^#!\s*(.+)'), 1, '')
      if empty(l:cmd)
        throw 'E:ShellOutput: command arg or shebang is required.'
      endif
    endif
    call vimrc#util#scratch_window(vimrc#util#get_select_text())
    execute '1,$!' . l:cmd
    return
  endif

  if empty(l:cmd)
    let l:cmd = expand('%:p')
    if !executable(l:cmd)
      throw 'E:ShellOutput: ' . l:cmd . ' is not executable.'
    endif
  endif

  call vimrc#util#scratch_window(system(l:cmd))
endfunction

command! -nargs=? -range=0 -complete=shellcmd
\ ShellOutput call s:ShellOutput(<count>, <q-args>)

function! s:GitDiff(...) abort
  let l:opts = a:0 && !empty(trim(a:1)) ? shellescape(a:1) : '--cached'
  call s:ShellOutput(0, "git diff " . l:opts)
  setlocal filetype=diff
endfunction
command! -nargs=? GitDiff call s:GitDiff(<q-args>)

function! s:GitGrep(search_string) abort
  let l:search_string = a:search_string
  if l:search_string ==# ''
    let l:search_string = expand('<cfile>')
  endif
  let l:command = printf('git grep -n %s', shellescape(l:search_string))
  let l:save_errorformat = &l:errorformat
  let &l:errorformat = '%f:%l%m'
  let l:success = 0
  try
    cgetexpr system(l:command)
    let l:success = 1
  finally
    let &l:errorformat = l:save_errorformat
  endtry
  if l:success && !empty(getqflist())
    copen
  endif
endfunction
command! -nargs=? GitGrep call s:GitGrep(<q-args>)

function! s:GitLogGraph(...) abort
  let l:target = a:0 && !empty(trim(a:1)) ? ' ' . shellescape(a:1) : ''
  let l:cmdline = 'git log --oneline --graph --all ' .
  \ '--date=short --decorate=short --format=' . shellescape("%h\t%ad\t%d\t%s") .
  \ l:target
  call vimrc#util#scratch_window(systemlist(l:cmdline))
  setlocal filetype=gitrebase
endfunction
command! -nargs=? GitLogGraph call s:GitLogGraph(<q-args>)

function! s:GitShow(...)
  if a:0 && !empty(a:1)
    let l:target = a:1
  elseif expand('<cword>') =~# '^\v\w+$'
    let l:target = expand('<cword>')
  else
    let l:target = 'HEAD'
  endif
  call vimrc#util#scratch_window(system('git show ' . shellescape(l:target)))
  setlocal filetype=gitcommit
endfunction
command! -nargs=? GitShow call s:GitShow(<q-args>)

function! s:DiffOrigin() abort
  let l:syntax = &l:syntax
  vert new
  let &l:syntax = l:syntax
  setlocal buftype=nofile nobuflisted undolevels=-1
  read ++edit #
  undojoin | 0d_
  diffthis
  wincmd p
  diffthis
endfunction
command! DiffOrig call s:DiffOrigin()

function! s:StartupTimeLog() abort
  let l:logfile = tempname()
  let l:vim_command = "vim --startuptime %s -c %s"
  let l:start_command = shellescape(printf(':edit %s', l:logfile))
  let l:vim_command = printf(l:vim_command, fnameescape(l:logfile), l:start_command)
  execute '!' . l:vim_command
endfunction
if !has('nvim')
  command! StartupTimeLog call s:StartupTimeLog()
endif

function! s:MemoDir() abort
  let l:memo_dir = get(g:, 'vimrc_memo_dir', '')
  if empty(l:memo_dir)
    throw 'E:MemoDir g:vimrc_memo_dir is empty'
  endif
  let l:memo_dir = vimrc#util#expand(l:memo_dir)
  if !isdirectory(l:memo_dir)
    throw 'E:MemoDir g:vimrc_memo_dir is not a directory'
  endif
  return l:memo_dir
endfunction

function! s:MemoNew(title) abort
  let l:dir = s:MemoDir()
  let l:title = empty(trim(a:title)) ? input('Title: ', '') : a:title
  if empty(trim(l:title)) | return | endif
  let l:name = substitute(l:title, '\v([/\\:*?"<>|]|\s)+', '_', 'g')
  let l:path = printf('%s/%s_%s.md', l:dir, strftime('%Y%m%d'), l:name)
  let l:path = substitute(l:path, '\v[\\/]+', '/', 'g')
  split `=l:path`
  if !filereadable(l:path)
    call setline(1, printf('# %s', l:title))
  endif
endfunction
command! -nargs=? MemoNew call s:MemoNew(<q-args>)

function! s:MemoFind(search) abort
  let l:dir = s:MemoDir()
  let l:search = empty(trim(a:search)) ? input('Search: ', '') : a:search
  if empty(trim(l:search)) | return | endif
  execute printf('grep %s %s', shellescape(l:search), fnameescape(l:dir))
endfunction
command! -nargs=? MemoFind call s:MemoFind(<q-args>)
