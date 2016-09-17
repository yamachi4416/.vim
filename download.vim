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

Plug 'FelikZ/ctrlp-py-matcher'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/vimproc.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'hujo/html5css3'
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'szw/vim-tags'
Plug 'thinca/vim-quickrun'
Plug 'thinca/vim-ref'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-endwise'

"ColorSchema
Plug 'nanotech/jellybeans.vim'
Plug 'w0ng/vim-hybrid'

Plug 'Shougo/unite.vim'
Plug 'tsukkee/unite-tag'

if has('lua')
  Plug 'Shougo/neocomplete'
  Plug 'Konfekt/FastFold'
endif

"NeoVim
if has('nvim')
  Plug 'Shougo/deoplete.nvim'
  Plug 'carlitux/deoplete-ternjs'
endif

"Vim
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-jp/vital.vim'

"NodeJs
if exists('$VIM_NODEJS')
  Plug 'moll/vim-node', { 'for': 'javascript' }
  Plug 'ternjs/tern_for_vim', { 'do': 'npm i', 'for': 'javascript' }
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
  Plug 'hujo/vim-ruby', { 'for': 'ruby', 'branch': 'add_nil_check' }
  Plug 'rhysd/unite-ruby-require.vim'
  Plug 'tpope/vim-rails'
  Plug 'yuku-t/vim-ref-ri'
  Plug 'mrk21/yaml-vim'
  Plug 'hujo/ctrlp-rubyrequire'
endif

"Haskell
if exists('$VIM_HASKELL')
  Plug 'kana/vim-filetype-haskell'
  Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
  Plug 'eagletmt/ghcmod-vim', { 'for': 'haskell' }
  Plug 'ujihisa/ref-hoogle'
  Plug 'eagletmt/unite-haddock'
endif

call s:_.SourceIfExists('$MYVIMFILES/localplug.vim')

call plug#end()
let &guioptions = s:save_guioptions
unlet! s:save_guioptions
