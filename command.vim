let s:_ = VIMRC._

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

command! -nargs=? GitGrepQuickfix call s:git_grep(<q-args>)
