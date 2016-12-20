let &l:path        = g:VIMRC._.AddRefPath('java/src', &l:path)
let &l:includeexpr = g:VIMRC._.SID('IncludeExpr(tr(v:fname,''.'',''/''))')
let &l:include     = '\v^import\s+'
let &l:suffixesadd = '.java'

let s:_ = g:VIMRC._

if s:_.IsInstall('vim-javacomplete2')
  setlocal omnifunc=javacomplete#Complete
endif

setlocal noexpandtab
