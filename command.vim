let s:_ = VIMRC._

command! -nargs=? -bang -complete=function
\ ScratchWindow call s:_.ScratchWindow(<bang>0 ? eval(<q-args>) : <q-args>)
