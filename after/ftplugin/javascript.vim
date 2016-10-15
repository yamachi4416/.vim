let &l:include     = '\v<require\s*\(\s*([''"])\zs\f+\ze\1?\)'
let &l:suffixesadd = '.js'
let &l:path        = VIMRC._.AddRefPath('javascript/node/lib', &l:path)
let &l:includeexpr = VIMRC._.SID('IncludeExpr(v:fname)')
