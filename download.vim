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
Plug 'cocopon/iceberg.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'hujo/html5css3'
Plug 'itchyny/lightline.vim'
Plug 'mattn/emmet-vim'
Plug 'neomake/neomake'
Plug 'thinca/vim-quickrun'
Plug 'thinca/vim-ref'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-jp/vital.vim'
Plug 'chr4/nginx.vim'

if executable('ctags')
  Plug 'majutsushi/tagbar'
  Plug 'szw/vim-tags'
endif

if has('lua')
  Plug 'Shougo/neocomplete'
  Plug 'Konfekt/FastFold'
endif

"NodeJs
if exists('$VIM_NODEJS')
  Plug 'moll/vim-node', { 'for': ['javascript', 'coffee'] }
  Plug 'ternjs/tern_for_vim', { 'do': 'npm i && npm i tern-coffee' }
  Plug 'othree/tern_for_vim_coffee'
  Plug 'kchmck/vim-coffee-script'
endif

"Python
if exists('$VIM_PYTHON')
  Plug 'davidhalter/jedi-vim', { 'for': 'python' }
  Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }
  if executable('pyenv')
    Plug 'lambdalisue/vim-pyenv', { 'for': 'python' }
  endif
endif

"Ruby
if exists('$VIM_RUBY')
  Plug 'vim-ruby/vim-ruby'
  Plug 'tpope/vim-rails'
  Plug 'yuku-t/vim-ref-ri'
  Plug 'hujo/ctrlp-rubyrequire'
endif

"Windows
if has('win32')
  Plug 'hujo/dosdos-complete-vim'
  Plug 'hujo/ref-doshelp'
endif

call s:_.SourceIfExists('$MYVIMFILES/localplug.vim')

call plug#end()
