let &l:include = '\v<require%(_relative)?\s*\(?\s*([''"])\zs\f+\ze\1?\)?$'
let &l:includeexpr = 'vimrc#util#includeexpr(v:fname)'

setl makeprg=rake
