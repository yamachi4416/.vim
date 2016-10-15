let &l:include = '\v<require%(_relative)?\s*\(?\s*([''"])\zs\f+\ze\1?\)?$'
let &l:includeexpr = VIMRC._.SID('IncludeExpr(v:fname)')
call VIMRC._.RubyAddBundlePaths()
