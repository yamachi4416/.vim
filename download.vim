let s:_ = g:VIMRC._

function! s:DownloadPlugVim(plugvim) abort
  if filereadable(a:plugvim) | return 1 | endif
  if !isdirectory($VIMPLUGDIR)
    call mkdir($VIMPLUGDIR)
  endif
  let l:repo = 'junegunn/vim-plug/master/plug.vim'
  call s:_.GetFileFromUrl('https://raw.githubusercontent.com/' . l:repo, a:plugvim)
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

Plug 'itchyny/lightline.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'ctrlpvim/ctrlp.vim'

Plug 'prabirshrestha/vim-lsp', has('nvim') ? { 'on': [] } : {}
Plug 'prabirshrestha/asyncomplete.vim', has('nvim') ? { 'on': [] } : {}
Plug 'prabirshrestha/asyncomplete-lsp.vim', has('nvim') ? { 'on': [] } : {}
Plug 'mattn/vim-lsp-settings', has('nvim') ? { 'on': [] } : {}

Plug 'neovim/nvim-lspconfig', has('nvim') ? {} : { 'on': [] }
Plug 'williamboman/mason.nvim', has('nvim') ? {} : { 'on': [] }
Plug 'williamboman/mason-lspconfig.nvim', has('nvim') ? {} : { 'on': [] }
Plug 'hrsh7th/nvim-cmp', has('nvim') ? {} : { 'on': [] }
Plug 'hrsh7th/cmp-nvim-lsp', has('nvim') ? {} : { 'on': [] }
Plug 'folke/lazydev.nvim', has('nvim') ? {} : { 'on': [] }

call s:_.SourceIfExists('$MYVIMFILES/.local/plugs.vim')

call plug#end()
