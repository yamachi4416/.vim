let g:neocomplete#data_directory = expand('$VIMCACHEDIR/neocomplete')
let g:neocomplete#enable_fuzzy_completion = 1
let g:neocomplete#enable_auto_select = 1
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_auto_delimiter = 1

call neocomplete#custom#source('tag', 'disabled_filetypes', {'_': 1})
call neocomplete#custom#source('include', 'disabled_filetypes', {'_': 1})

let g:neocomplete#force_omni_input_patterns =
\ get(g:, 'neocomplete#force_omni_input_patterns', {})
let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#force_omni_input_patterns.cs = '[^.]\.\%(\u\{2,}\)\?'
let g:neocomplete#force_omni_input_patterns.coffee = '[^.]\.\%(\u\{2,}\)\?'

function! g:VIMRC._AUTOCMDS_.Neocomplete()
  au filetype ruby NeoCompleteLock
endfunction

