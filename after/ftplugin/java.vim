let s:_ = g:VIMRC._

let &l:path        = g:VIMRC._.AddRefPath('java/src', &l:path)
let &l:includeexpr = g:VIMRC._.SID('IncludeExpr(tr(v:fname,''.'',''/''))')
let &l:include     = '\v^import\s+'
let &l:suffixesadd = '.java'

let java_ignore_javadoc  = 1
let java_comment_strings = 1

setlocal noexpandtab
setlocal foldmethod=syntax
setlocal makeprg=ant

if !s:_.IsInstall('vim-javacomplete2')
  finish
endif

setlocal omnifunc=javacomplete#Complete

function! s:JCimports()
  JCimportsRemoveUnused
  JCimportsAddMissing
  JCimportsSort
endfunction

nnoremap <silent><buffer><leader>jo :<C-u>call <SID>JCimports()<CR>
