nnoremap [jedi] <nop>
xnoremap [jedi] <Nop>

let g:jedi#goto_assignments_command = '[jedi]g'
let g:jedi#got_definitions_command = '[jedi]d'
let g:jedi#rename_command = '[jedi]r'
let g:jedi#usages_command = '[jedi]n'

functio! s:JediKeyMap()
  nmap <leader>j [jedi]
  xmap <leader>j [jedi]
endfunctio

function! VIMRC._AUTOCMDS_.Jedi()
  au filetype python call s:JediKeyMap()
endfunction

