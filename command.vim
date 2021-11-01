let s:_ = g:VIMRC._

command! -nargs=? -bang -complete=function
\ ScratchWindow call s:_.ScratchWindow(<bang>0 ? eval(<q-args>) : <q-args>)

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

const s:OLD_PYTHON_HOME = $PYTHONHOME
const s:OLD_VIRTUAL_PATH = $PATH

function! s:SetpythonDll() abort
  if !exists('&pythonthreedll') | return | endif
  if executable('python')
    let &pythonthreedll = expand(fnamemodify(exepath('python'), ':p:h') . '/python3?.dll')
  else
    let &pythonthreedll = ''
  endif
endfunction
call s:SetpythonDll()

function! s:ActivateVenv(env_dir) abort
  let l:env_path = fnamemodify(expand(a:env_dir), ':p')
  if isdirectory(l:env_path)
    let $VIRTUAL_ENV = fnamemodify(l:env_path, ':s?/$??')
    if has('win32')
      let $PATH = l:env_path . 'Scripts;' . s:OLD_VIRTUAL_PATH
    else
      let $PATH = l:env_path . 'bin:' . s:OLD_VIRTUAL_PATH
    endif
    call s:_.DelEnv('PYTHONHOME')
    call s:SetpythonDll()
  else
    throw a:env_dir . ' is not directory'
  endif
endfunction
command! -complete=dir -nargs=1 VenvActivate call s:ActivateVenv(<q-args>)

function! s:DeactivateVenv() abort
  let $PATH = s:OLD_VIRTUAL_PATH
  let $PYTHONHOME = s:OLD_PYTHON_HOME
  call s:_.DelEnv('VIRTUAL_ENV')
  call s:SetpythonDll()
endfunction
command! VenvDeactivate call s:DeactivateVenv()

function! s:StartupTimeLog() abort
  let l:logfile = tempname()
  let l:vim_command = "vim --startuptime %s -c %s"
  let l:start_command = shellescape(printf(':edit %s', l:logfile))
  let l:vim_command = printf(l:vim_command, l:logfile, l:start_command)
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
  setlocal buftype=nofile
  let &l:syntax = l:syntax
  r ++edit #
  0d_
  diffthis
  wincmd p
  diffthis
endfunction
command! DiffOrig call s:DiffOrigin()

