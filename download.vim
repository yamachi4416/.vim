let s:_ = g:VIMRC._

function! s:DownloadPlugVim(plugvim) abort
  if filereadable(a:plugvim) | return 1 | endif
  if !isdirectory($VIMPLUGDIR) | call mkdir($VIMPLUGDIR) | endif
  let repo = 'junegunn/vim-plug/master/plug.vim'
  call s:_.GetFileFromUrl('https://raw.githubusercontent.com/' . repo, a:plugvim)
endfunction

let g:plug_home = $VIMPLUGDIR
let g:plug_url_format = 'https://github.com/%s.git'
if !exists(':PlugInstall')
  call s:DownloadPlugVim(expand('$VIMPLUGDIR/plug.vim'))
  if !s:_.SourceIfExists('$VIMPLUGDIR/plug.vim')
    finish
  endif
endif

call plug#begin($VIMPLUGDIR)

Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'chr4/nginx.vim', { 'for': 'nginx' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'hujo/html5css3', { 'for': ['html', 'css'] }
Plug 'itchyny/lightline.vim'
Plug 'neomake/neomake'
Plug 'thinca/vim-quickrun'
Plug 'thinca/vim-ref'
Plug 'tpope/vim-endwise'
Plug 'vim-jp/vital.vim'

if has('lua')
  Plug 'Shougo/neocomplete'
  Plug 'Konfekt/FastFold'
endif

"NodeJs
if executable('node')
  Plug 'moll/vim-node', { 'for': 'javascript' }
  Plug 'ternjs/tern_for_vim', { 'do': 'npm i', 'for': 'javascript' }
endif

"Python
if executable('python') || executable('py')
  Plug 'davidhalter/jedi-vim', { 'for': 'python' }
  Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }
endif

"Ruby
if executable('ruby')
  Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
  Plug 'yuku-t/vim-ref-ri', { 'for': 'ruby' }
  Plug 'hujo/ctrlp-rubyrequire', { 'for': 'ruby' }
  Plug 'tpope/vim-rails', { 'for': 'ruby' }
endif

call s:_.SourceIfExists('$MYVIMFILES/localplug.vim')

call plug#end()
