let s:_ = g:VIMRC._

let s:OLD_PYTHON_HOME = $PYTHONHOME
let s:OLD_VIRTUAL_PATH = $PATH

function! s:setpython_dll() abort
  if !exists('&pythonthreedll') | return | endif
  if executable('python')
    let &pythonthreedll = expand(fnamemodify(exepath('python'), ':p:h') . '/python3?.dll')
  else
    let &pythonthreedll = ''
  endif
endfunction

function! s:activate_venv(env_dir) abort
  let env_path = fnamemodify(expand(a:env_dir), ':p')
  echo env_path
  if isdirectory(env_path)
    let $VIRTUAL_ENV = env_path
    let $PYTHONHOME = ''
    let $PATH = $VIRTUAL_ENV . '\Scripts;' . s:OLD_VIRTUAL_PATH
    call s:setpython_dll()
  else
    throw a:env_dir . ' is not directory'
  endif
endfunction

function! s:deactivate_venv() abort
  let $PATH = s:OLD_VIRTUAL_PATH
  let $PYTHONHOME = s:OLD_PYTHON_HOME
  unlet! $VIRTUAL_ENV
  call s:setpython_dll()
endfunction

call s:setpython_dll()

command! -complete=dir -nargs=1  VenvActivate call s:activate_venv(<q-args>)
command! VenvDeactivate call s:deactivate_venv()

command! -nargs=? -bang -complete=function
\ ScratchWindow call s:_.ScratchWindow(<bang>0 ? eval(<q-args>) : <q-args>)

function! s:vim_startup_log()
  let logfile = tempname()
  let vim_command = "vim --startuptime %s -c %s"
  let start_command = shellescape(printf(':edit %s', logfile))
  let vim_command = printf(vim_command, logfile, start_command)
  execute '!' . vim_command
endfunction

command! StartupTime call s:vim_startup_log()

function! s:git_grep(search_string)
  let search_string = a:search_string
  if search_string ==# ''
    let search_string = expand('<cfile>')
  endif
  let command = printf('git grep -n %s', shellescape(search_string))
  let save_errorformat = &l:errorformat
  let &l:errorformat = '%f:%l%m'
  let success = 0
  try
    cgetexpr system(command)
    let success = 1
  finally
    let &l:errorformat = save_errorformat
  endtry
  if success && !empty(getqflist())
    copen
  endif
endfunction

command! -nargs=? QfGitDiff if s:_.QfGitDiff(<q-args>) | copen | endif

command! -nargs=? GitGrepQuickfix call s:git_grep(<q-args>)

command! -nargs=? CreateDictUseSyntax call s:_.CreateDictUseSyntax()

function! s:CopyToTermClip(value) abort
  if executable('base64')
    let val = substitute(system('base64', a:value), '\n', '', 'g')
    exe printf('silent! !echo -ne "\e]52;c;%s\x07"', val)
    redraw!
  endif
endfunction

command! -nargs=1 -complete=function CopyToTermClip call s:CopyToTermClip(<args>)
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
