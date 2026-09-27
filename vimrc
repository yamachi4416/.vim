set encoding=utf8
scriptencoding utf-8

if !1 | finish | endif

let s:IsWindows = has('win32')
let s:IsUnix = has('unix')
let s:IsNvim = has('nvim')

function! s:SetEnv() abort
  if !has('vim_starting') | return | endif

  let $MYVIMDIR  = expand('<script>:p:h')
  let $VIMPLUGDIR  = expand('$MYVIMDIR/.local/plugs')
  let $VIMCACHEDIR = expand('$MYVIMDIR/.local/cache')

  if s:IsNvim
    set runtimepath^=$MYVIMDIR
    set runtimepath+=$MYVIMDIR/after
    let &packpath = &runtimepath
  endif

  let l:path_sep = s:IsWindows ? ';' : ':'
  let l:paths = split($PATH, l:path_sep)

  if s:IsWindows && isdirectory(expand('$SCOOP'))
    call extend(l:paths, [expand('$SCOOP/shims')])
  endif

  if isdirectory(expand('$PROTO_HOME'))
    call extend(l:paths, [
    \ expand('$PROTO_HOME/shims'),
    \ expand('$PROTO_HOME/bin'),
    \])
  endif

  let $PATH = join(l:paths, l:path_sep) . l:path_sep
endfunction

function! s:SetStartingVimOptions() abort
  if !has('vim_starting') | return | endif
  set nobomb
  set fileencoding=
  set fileencodings=ucs-bom,utf8,sjis,cp932,eucjp,default,latin
  "set fileformat=
  set fileformats=unix,dos
  set helplang=en,ja
  set autoread
  set novisualbell noerrorbells belloff=all
  set clipboard& clipboard+=unnamed
  set softtabstop=-1 shiftwidth=0 tabstop=2 expandtab
endfunction

function! s:SetEditVimOptions() abort
  set mouse=a
  set modeline
  set ignorecase smartcase
  if exists('&tagcase')
    set tagcase=match
  endif
  set virtualedit=block backspace=2
  set completeopt=menuone,longest,preview
  set nojoinspaces
  set iminsert=0 formatoptions=cqrj nolinebreak
  set copyindent preserveindent
  if exists('&fixendofline')
    set nofixendofline
  endif
  set nospell
  set spelllang=en_us,cjk
  if exists('&spelloptions')
    set spelloptions=camel
  endif
endfunction

function! s:SetBufFileVimOptions() abort
  set isfname& isfname-== isfname-=!
  set hidden
  set wildignorecase wildignore&
  set tags=tags;
endfunction

function! s:SetDisplayVimOptions() abort
  set list listchars=tab:>\ ,trail:- ambiwidth=double fillchars=
  set noshowmatch matchtime=0
  set hlsearch incsearch
  set whichwrap=[,],<,>
  set number
  set ruler
  set synmaxcol=0
  set noequalalways scrolloff=0 splitright splitbelow
  set sidescroll=1 sidescrolloff=1
  set foldopen& foldopen-=block foldopen+=jump foldlevelstart=99
  set foldlevel=99 foldminlines=0 foldmethod=indent
  if exists('&breakindent')
    set wrap breakindent
    set breakindentopt& breakindentopt+=shift:4
  else
    set nowrap
  endif
  let &g:statusline =
  \ ' %{pathshorten(getcwd())} %{expand(''%'')} %m%r%w %=%{join([&fenc,&ff])} '
  set showtabline=2
  if exists(':sign')
    set signcolumn=yes
  endif
endfunction

function! s:SetCmdAndTermVimOptions() abort
  set showcmd laststatus=2 cmdwinheight=10 cmdheight=2
  set wildmenu wildmode=longest:full wildoptions=fuzzy
  set cmdwinheight=5

  if has('vim_starting') && !has('gui_running')
    if has('termguicolors')
      set termguicolors
    else
      set t_Co=256
    endif
    if &term =~ 'xterm' || &term == 'win32'
      let &t_SI = "\e[6 q"    " vertical bar cursor
      let &t_SR = "\e[4 q"    " underline cursor
      let &t_EI = "\e[2 q"    " block cursor
      let &t_ti ..= "\e[2 q"  " block cursor
      let &t_te ..= "\e[0 q"  " default (depends on terminal, normally blink block)
    endif
  endif
endfunction

function! s:SetBackupUndoVimOptions() abort
  set nobackup nowritebackup noswapfile
  set history=100 viminfo-=!

  if s:IsNvim
    set undodir=$VIMCACHEDIR/undo/nvim
    set viminfofile=$VIMCACHEDIR/.nviminfo
  else
    set undodir=$VIMCACHEDIR/undo/vim
    set viminfofile=$VIMCACHEDIR/.viminfo
  endif

  if has('persistent_undo')
    if !isdirectory(&undodir)
      call mkdir(&undodir, 'p')
    endif
    set undofile
  endif
endfunction

function! s:FileTypeAutoCommand() abort
  let l:filetype = expand('<amatch>')
  setlocal formatoptions-=o
  setlocal smartindent
  setlocal complete-=i complete-=t
  if &l:path ==# ''
    setlocal path<
  endif
  let l:dict = $MYVIMDIR .'/.local/dict/' . l:filetype . '.txt'
  if filereadable(l:dict)
    execute 'setlocal dict+=' . l:dict
    execute 'setlocal complete+=k' . l:dict
  endif
endfunction

function! s:InitAutogroup() abort
  augroup Vimrc
    autocmd!
    autocmd bufnewfile *.{bat,cmd}
    \ setlocal fileencoding=cp932 fileformat=dos
    autocmd bufnewfile,bufreadpost *.jade
    \ setlocal filetype=pug
    autocmd filetype *
    \ call s:FileTypeAutoCommand()
  augroup END
endfunction

function! s:LoadPluginConfig() abort
  for l:config in globpath($MYVIMDIR, 'config/*', 1, 1)
    let l:file = vimrc#util#fname_part(l:config)
    if vimrc#util#is_installed(l:file.name)
      call vimrc#util#source(l:config)
    endif
  endfor
endfunction

let g:vimrc_loaded = 0

call s:SetEnv()
call vimrc#util#source('$MYVIMDIR/.local/vimrc.vim')
call vimrc#util#source('$MYVIMDIR/globalvar.vim')

call s:InitAutogroup()
call s:SetStartingVimOptions()
call s:SetEditVimOptions()
call s:SetBufFileVimOptions()
call s:SetDisplayVimOptions()
call s:SetCmdAndTermVimOptions()
call s:SetBackupUndoVimOptions()

call vimrc#util#source('$MYVIMDIR/download.vim')
call vimrc#util#source('$MYVIMDIR/config/plugin.vim')
call vimrc#util#source('$MYVIMDIR/config/plugin.lua')
call s:LoadPluginConfig()

syntax enable
call vimrc#util#source('$MYVIMDIR/mapping.vim')

let g:vimrc_loaded = 1
call vimrc#util#source('$MYVIMDIR/.local/vimrc.vim')

set secure
