let &l:include = '\v<require%(_relative)?\s*\(?\s*([''"])\zs\f+\ze\1?\)?$'
let &l:includeexpr = g:VIMRC._.SID('IncludeExpr(v:fname)')

setl makeprg=rake
