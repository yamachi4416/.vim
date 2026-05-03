let s:_ = g:VIMRC._

command! -nargs=? -bang -complete=function
\ ScratchWindow call s:_.ScratchWindow(<bang>0 ? eval(<q-args>) : <q-args>)

function! s:ShellOutput(range, cmd) abort
  let l:cmd = a:cmd

  if a:range
    if empty(l:cmd)
      let l:cmd = get(matchlist(getline(1), '\v^#!\s*(.+)'), 1, '')
      if empty(l:cmd)
        throw 'E:ShellOutput: command arg or shebang is required.'
      endif
    endif
    call s:_.ScratchWindow(s:_.GetSelectText())
    execute '1,$!' . l:cmd
    return
  endif

  if empty(l:cmd)
    let l:cmd = expand('%:p')
    if !executable(l:cmd)
      throw 'E:ShellOutput: ' . l:file . 'is not executable.'
    endif
  endif

  call s:_.ScratchWindow(system(l:cmd))
endfunction

command! -nargs=? -range=0 -complete=shellcmd
\ ShellOutput call s:ShellOutput(<count>, <q-args>)

function! s:GitDiffScrachWindow() abort
  call s:ShellOutput(0, "git diff --cached")
  setlocal filetype=diff
endfunction

command! GitDiffScrachWindow call s:GitDiffScrachWindow()

function! s:CreateDictUseSyntax() abort
  if &l:syntax ==# '' || &l:syntax ==# 'text'
    return
  endif

  let l:file = expand('$MYVIMFILES/dict/' . &l:syntax . '.txt')
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

function! s:QfGitDiff(...) abort
  let [l:lnum, l:ret] = [0, []]
  let l:dir = matchstr(system('git rev-parse --show-toplevel'), '\v^\f+\ze[\r\n]')

  if empty(l:dir) | return | endif

  for l:line in split(system(printf('git diff %s', a:0 ? a:1 : '')), '\v\r\n|\n|\r')
    if l:line[:3] ==# 'diff'
      let [l:lnum, l:fname] = [0, l:dir . '/' . matchstr(l:line, '\v\sb/\zs\f+$')]
      continue
    endif
    let l:char = l:line[0]
    if l:char ==# '@'
      let l:lnum = str2nr(matchstr(l:line, '\v\+\d+'))
      continue
    endif
    if l:lnum
      if l:char ==# '+' || l:char ==# '-'
        call add(l:ret, {
        \ 'filename': l:fname, 'type': 'i', 'lnum': l:lnum, 'col': 1, 'text': l:line})
      endif
      let l:lnum = stridx('-\', l:char) + 1 ? l:lnum : l:lnum + 1
    endif
  endfor

  call setqflist(l:ret, 'r')

  return len(l:ret) ? 1 : 0
endfunction
command! -nargs=? QfGitDiff if s:QfGitDiff(<q-args>) | copen | endif

function! s:SetpythonDll() abort
  if !exists('&pythonthreedll') | return | endif
  if executable('python')
    let &pythonthreedll = expand(fnamemodify(exepath('python'), ':p:h') . '/python3?.dll')
  else
    let &pythonthreedll = ''
  endif
endfunction
call s:SetpythonDll()

function! s:StartupTimeLog() abort
  let l:logfile = tempname()
  let l:vim_command = "vim --startuptime %s -c %s"
  let l:start_command = shellescape(printf(':edit %s', l:logfile))
  let l:vim_command = printf(l:vim_command, fnameescape(l:logfile), l:start_command)
  execute '!' . l:vim_command
endfunction
command! StartupTimeLog call s:StartupTimeLog()

function! s:GitGrepQuickfix(search_string) abort
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
command! -nargs=? GitGrepQuickfix call s:GitGrepQuickfix(<q-args>)

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

