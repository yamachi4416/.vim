let s:_ = VIMRC._

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
  if (!s:_.SourceIfExists('$VIMPLUGDIR/plug.vim'))
    finish
  endif
endif

let s:save_guioptions = &guioptions
set guioptions=
call plug#begin($VIMPLUGDIR)

Plug 'ctrlpvim/ctrlp.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'hujo/ctrlp-pipe'
Plug 'hujo/html5css3'
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'nanotech/jellybeans.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'thinca/vim-quickrun'
Plug 'thinca/vim-ref'
Plug 'cohama/lexima.vim'
Plug 'tpope/vim-fugitive'

if has('lua')
  Plug 'Shougo/neocomplete'
  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets'
  Plug 'Konfekt/FastFold'
endif

"Vim
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-jp/vital.vim'

"JS
Plug 'https://bitbucket.org/teramako/jscomplete-vim.git'
Plug 'hujo/jscomplete-html5API'

"NodeJs
if exists('$VIM_NODEJS')
  Plug 'moll/vim-node'
  Plug 'ternjs/tern_for_vim', { 'do': 'npm i' }
  Plug 'briancollins/vim-jst'
  Plug 'digitaltoad/vim-pug'
endif

"Python
if exists('$VIM_PYTHON')
  Plug 'davidhalter/jedi-vim', { 'for': 'python' }
  Plug 'lambdalisue/vim-pyenv', { 'for': 'python' }
  Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }
  Plug 'lambdalisue/vim-django-support', { 'for': 'python' }
endif

"Ruby
if exists('$VIM_RUBY')
  Plug 'vim-ruby/vim-ruby'
  Plug 'tpope/vim-rails'
  Plug 'yuku-t/vim-ref-ri'
  Plug 'hujo/ctrlp-rubyrequire'
  Plug 'mrk21/yaml-vim'
endif

call s:_.SourceIfExists('$MYVIMFILES/localplug.vim')

call plug#end()
let &guioptions = s:save_guioptions
unlet! s:save_guioptions
