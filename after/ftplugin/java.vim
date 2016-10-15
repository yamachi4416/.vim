let &l:path        = VIMRC._.AddRefPath('java/src', &l:path)
let &l:includeexpr = VIMRC._.SID('IncludeExpr(tr(v:fname,''.'',''/''))')
let &l:include     = '\v^import\s+'
let &l:suffixesadd = '.java'
