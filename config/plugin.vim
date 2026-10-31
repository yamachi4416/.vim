let g:mapleader = "\\"

let g:syntax_cmd = ''

" $VIMRUNTIME/plugin/matchparen.vim
let g:matchparen_timeout = 200
let g:matchparen_insert_timeout = 200

" $VIMRUNTIME/syntax/xml.vim
let g:xml_syntax_folding = 1

" $VIMRUNTIME/indent/html.vim
let g:html_indent_inctags = ''
let g:html_indent_autotags = 'th,td,tr,tfoot,thead'

" $VIMRUNTIME/indent/vim.vim
let g:vim_indent_cont = 0

" $VIMRUNTIME/syntax/vim.vim
let g:vimsyn_embed = ''
let g:vimsyn_folding = 'af'
let g:vimsyn_noerror = 1

" $VIMRUNTIME/autoload/htmlcomplete.vim
let g:uppercase_tag = 0

" $VIMRUNTIME/autoload/rubycomplete.vim
let g:rubycomplete_rails = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_include_object = 1
let g:rubycomplete_include_objectspace = 1
let g:rubycomplete_load_gemfile = 1

let g:ruby_space_errors = 1
let g:ruby_fold = 1

" $VIMRUNTIME/syntax/python.vim
let g:python_space_error_highlight = 1

" $VIMRUNTIME/syntax/markdown.vim
let g:markdown_fenced_languages = [
\ 'css',
\ 'java',
\ 'javascript',
\ 'python',
\ 'ruby',
\ 'sass',
\ 'sh',
\ 'sql',
\ 'typescript',
\ 'vue',
\]

let g:netrw_banner    = 0
let g:netrw_alto      = 0
let g:netrw_preview   = 1
let g:netrw_liststyle = 0
let g:netrw_list_hide = '.git/'
let g:netrw_winsize   = 20
let g:netrw_timefmt   = '%Y-%m-%d %H:%M:%S'
let g:netrw_sizestyle = 'H'
let g:netrw_home      = $VIMCACHEDIR
let g:netrw_keepdir   = 1

if get(g:, 'loaded_matchit', 0)
  call vimrc#util#source('$VIMRUNTIME/macros/matchit.vim')
endif
