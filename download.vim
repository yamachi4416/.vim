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

Plug 'ctrlpvim/ctrlp.vim'
Plug 'itchyny/lightline.vim'
Plug 'thinca/vim-quickrun'
Plug 'vim-jp/vital.vim'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

call s:_.SourceIfExists('$MYVIMFILES/localplug.vim')

call plug#end()
