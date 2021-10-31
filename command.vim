let s:_ = g:VIMRC._

command! -nargs=? QfGitDiff if s:_.QfGitDiff(<q-args>) | copen | endif
command! -nargs=? CreateDictUseSyntax call s:_.CreateDictUseSyntax()
command! -nargs=? -bang -complete=function
\ ScratchWindow call s:_.ScratchWindow(<bang>0 ? eval(<q-args>) : <q-args>)

let s:OLD_PYTHON_HOME = $PYTHONHOME
let s:OLD_VIRTUAL_PATH = $PATH

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

