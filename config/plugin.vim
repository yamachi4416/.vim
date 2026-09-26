let s:_ = g:VIMRC._

if get(g:, 'loaded_matchit', 0)
  call s:_.SourceIfExists('$VIMRUNTIME/macros/matchit.vim')
endif

let g:netrw_banner    = 0
let g:netrw_preview   = 1
let g:netrw_liststyle = 0
let g:netrw_winsize   = 30
let g:netrw_alto      = 0
let g:netrw_timefmt   = '%Y-%m-%d %H:%M:%S'
let g:netrw_sizestyle = 'H'
let g:netrw_home      = $VIMCACHEDIR
