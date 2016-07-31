let s:_ = VIMRC._

command! -nargs=? -bang -complete=function
\ ScratchWindow call s:_.ScratchWindow(<bang>0 ? eval(<q-args>) : <q-args>)

function s:vim_startup_log()
  let logfile = tempname()
  let vim_command = "vim --startuptime %s -c %s"
  let start_command = shellescape(printf(':edit %s', logfile))
  let vim_command = printf(vim_command, logfile, start_command)
  execute '!' . vim_command
endfunction

command! StartupTime call s:vim_startup_log()
