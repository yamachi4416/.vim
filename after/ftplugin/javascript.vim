let &l:include     = '\v<require\s*\(\s*([''"])\zs\f+\ze\1?\)'
let &l:suffixesadd = '.js'
let &l:path        = g:VIMRC._.AddRefPath('javascript/node/lib', &l:path)
let &l:includeexpr = g:VIMRC._.SID('IncludeExpr(v:fname)')
