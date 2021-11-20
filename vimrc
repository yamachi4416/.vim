set encoding=utf8
scriptencoding utf-8

if !1 | finish | endif

let s:RC = {'_': {}}

function! s:RC._SetEnv() abort
  if !has('vim_starting') | return | endif
  let g:skip_defaults_vim = 1
  let $MYVIMFILES  = globpath('~', self.IsWindows ? 'vimfiles' : '.vim')
  let $VIMPLUGDIR  = expand('$MYVIMFILES/bundle/')
  let $VIMCACHEDIR = expand('$MYVIMFILES/.cache/')
  if exists('&pyxversion')
    set pyxversion=3
  endif

  if self.IsWindows && isdirectory(expand('$SCOOP'))
    let l:scoop = expand('$SCOOP/shims/')
    let $PATH = l:scoop . ';' . $PATH
  endif
endfunction

function! s:RC._SetStartingVimOptions() abort
  if !has('vim_starting') | return | endif
  set nobomb
  set fileencoding=
  set fileencodings=ucs-bom,utf8,sjis,cp932,eucjp,default,latin
  set fileformat=
  set fileformats=unix,dos
  set helplang=en,ja
  set autoread
  set novisualbell noerrorbells belloff=all
  set clipboard& clipboard+=unnamed
  set softtabstop=-1 shiftwidth=0 tabstop=2 expandtab
endfunction

function! s:RC._SetEditVimOptions() abort
  set mouse=a
  set modeline
  set ignorecase smartcase
  if exists('&tagcase')
    set tagcase=match
  endif
  set virtualedit=block backspace=2
  set completeopt=menuone,longest
  set nojoinspaces
  set iminsert=0 formatoptions=cqrj nolinebreak
  set copyindent preserveindent
  if exists('&fixendofline')
    set nofixendofline
  endif
  set nospell
  set spelllang=en_us,cjk
endfunction

function! s:RC._SetBufFileVimOptions() abort
  set isfname& isfname-== isfname-=!
  set hidden
  set wildignorecase wildignore& wildignore+=.git,.hg,.svn
  set tags=tags;
endfunction

function! s:RC._SetDisplayVimOptions() abort
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
  set guioptions=ecM
  set showtabline=2
  if exists(':sign')
    set signcolumn=yes
  endif
endfunction

function! s:RC._SetCmdAndTermVimOptions() abort
  set showcmd laststatus=2 cmdwinheight=10 cmdheight=2
  set wildmenu wildmode=longest:full
  set cmdwinheight=5
  if &term =~? '^win' && has('vim_starting')
    set termencoding=cp932
    let $PROMPT = get(v:, 'servername', 'VIM') . ' $P$_$S$G$S'
  endif
endfunction

function! s:RC._SetBackupUndoVimOptions() abort
  set nobackup nowritebackup noswapfile
  set history=100 viminfo-=!
  if has('persistent_undo')
    if !isdirectory($VIMCACHEDIR . '/undo')
      call mkdir(expand($VIMCACHEDIR  . '/undo'), 'p')
    endif
    set undofile undodir=$VIMCACHEDIR/undo
    let &wildignore .= ',' . &undodir
  endif
endfunction

function! s:RC._DefineGlobalVariables() abort
  call s:SourceIfExists('$MYVIMFILES/globalvar.vim')
endfunction

function! s:RC._DefineLocalFunctions() abort
  function! s:SID(...)
    let l:id = matchstr(string(function('s:SID')), '\C\v\<SNR\>\d+_')
    return a:0 < 1 ? l:id : l:id . a:1
  endfunction

  function! s:VimEnter() abort
    if &filetype !=# ''
      execute 'doautocmd filetype' &filetype
    endif
  endfunction

  function! s:Splitn(str) abort
    return split(a:str, '\v\r\n|\n|\r')
  endfunction

  function! s:WinSplit(cmd) abort
    let l:wincmd = (winwidth(0) * 1.0 / winheight(0) <= 4.0 ? '' : 'vert ') . a:cmd
    execute l:wincmd
  endfunction

  function! s:IMode(...) abort
    if pumvisible()
      return get(a:000, 0, '')
    elseif &l:omnifunc !=# ''
      return "\<C-x>\<C-o>\<C-p>"
    elseif !empty(tagfiles())
      return "\<C-x>\<C-]>"
    endif
    return "\<C-p>"
  endfunction

  function! s:ScratchWindow(...) abort
    call s:WinSplit('new')
    setlocal buftype=nofile bufhidden=wipe noswapfile
    if a:0
      if type(a:1) is type('')
        call append(line('$') - 1, s:Splitn(a:1))
      elseif type(a:1) is type([])
        call append(line('$') - 1, a:1)
      endif
    endif
    keepjumps normal! gg
    nnoremap <buffer><silent><C-l> :<C-u>%d _ <Bar>redraw<CR>
  endfunction

  function! s:IncludeExpr(fname) abort
    let l:suff = &l:suffixesadd
    let l:file = fnamemodify(a:fname, ':e') ==# '' ? a:fname . suff : a:fname
    let l:base = join(add(split(&l:path, ','), get(b:, 'base_path', '')), ',')
    let l:ret = s:Splitn(globpath(l:base, l:file, 0))
    if len(l:ret) == 0
      let l:ret = glob('./**/' . l:file)
    else
      let l:ret += [l:file]
    endif
    return filereadable(l:ret[0]) ? l:ret[0] : v:fname
  endfunction

  function! s:GetFileFromUrl(url, file) abort
    if executable('powershell') || executable('pwsh')
      let l:powershell = executable('pwsh') ? 'pwsh' : 'powershell'
      let l:powershell .= ' -NoLog -NoProfile -ExecutionPolicy RemoteSiged -Command '
      let l:command = '(New-Object System.Net.WebClient).DownloadFile(''%s'', ''%s'')'
      call system(l:powershell . shellescape(printf(l:command, a:url, a:file)))
    elseif executable('curl')
      let l:command = 'curl -fLo %s %s'
      call system(printf(l:command, shellescape(a:file), a:url))
    endif
  endfunction

  function! s:SourceIfExists(path) abort
    let l:filepath = expand(a:path)
    if filereadable(l:filepath)
      source `=l:filepath`
      return 1
    endif
    return 0
  endfunction

  function! s:GetSelectText() abort
    let l:save = @@
    silent normal! gvy
    let [l:ret, @@] = [@@, l:save]
    return l:ret
  endfunction

  function! s:IsInstalled(dirname) abort
    if exists('g:plugs')
      return has_key(g:plugs, a:dirname) || has_key(g:plugs, a:dirname . '.vim')
    endif
    return &runtimepath =~# '\v[\\/]' . a:dirname . ',?'
  endfunction

  function! s:FileTypeAutoCommand() abort
    setlocal formatoptions-=o cindent
    setlocal complete-=i complete-=t
    if &l:path ==# ''
      setlocal path<
    endif
    if filereadable(expand('$MYVIMFILES/dict/' . expand('<amatch>') . '.txt'))
      let &l:dict = glob('$MYVIMFILES/dict/' . expand('<amatch>') . '.txt')
      let &l:complete .= ',k' . &l:dict
    endif
  endfunction

  function s:DelEnv(env_name) abort
    if !exists('$' . a:env_name)
      return
    endif

    if has('perl')
      silent! execute "perl delete $ENV{'" . a:env_name . "'}"
    elseif has('ruby')
      silent! execute "ruby ENV.delete('" . a:env_name . "')"
    else
      silent! execute 'unlet! $' . a:env_name
    endif
  endfunction

  call extend(self._, {
  \ 'SID': function('s:SID'),
  \ 'IMode': function('s:IMode'),
  \ 'ScratchWindow': function('s:ScratchWindow'),
  \ 'IncludeExpr': function('s:IncludeExpr'),
  \ 'GetFileFromUrl': function('s:GetFileFromUrl'),
  \ 'SourceIfExists': function('s:SourceIfExists'),
  \ 'GetSelectText': function('s:GetSelectText'),
  \ 'IsInstalled': function('s:IsInstalled'),
  \ 'DelEnv': function('s:DelEnv'),
  \})
endfunction

function! s:RC._InitAutogroup() abort
  augroup Vimrc
    autocmd!
    autocmd bufnewfile *
    \ setlocal fileencoding=utf8
    autocmd bufnewfile *.{bat,cmd}
    \ setlocal fileencoding=cp932 fileformat=dos
    autocmd bufnewfile,bufreadpost *.jade
    \ setlocal filetype=pug
    autocmd filetype *
    \ call s:FileTypeAutoCommand()
    autocmd vimenter *
    \ call s:VimEnter()
  augroup END
endfunction


function! s:RC.SetVimOptions() abort
  call self._SetStartingVimOptions()
  call self._SetEditVimOptions()
  call self._SetBufFileVimOptions()
  call self._SetDisplayVimOptions()
  call self._SetCmdAndTermVimOptions()
  call self._SetBackupUndoVimOptions()
endfunction

function! s:RC.SetPluginEnable() abort
  if !has('vim_starting') | return | endif
  call s:SourceIfExists('$MYVIMFILES/download.vim')
endfunction

function! s:RC.LoadPluginConfig() abort
  call s:SourceIfExists('$MYVIMFILES/config/plugin.vim')
  for l:config in split(globpath($MYVIMFILES, 'config/*.vim', 1), "\n")
    if s:IsInstalled(matchstr(config, '\vconfig[\/]\zs[^\/]+\ze\.vim'))
      source `=config`
    endif
  endfor
endfunction

function! s:RC.LoadKeyMap() abort
  call s:SourceIfExists('$MYVIMFILES/mapping.vim')
endfunction

function! s:RC.LoadCommand() abort
  call s:SourceIfExists('$MYVIMFILES/command.vim')
endfunction

function! s:RC.Init() abort
  let self.IsWindows = has('win32')
  let self.IsUnix = has('unix')
  call self._DefineLocalFunctions()
  call self._SetEnv()
  call s:SourceIfExists('$MYVIMFILES/localconf.vim')
  call self._DefineGlobalVariables()
  call self._InitAutogroup()
  call self.SetVimOptions()
  return self
endfunction

function! s:RC.LoadLocalrc() abort
  call s:SourceIfExists('$MYVIMFILES/localrc.vim')
endfunction

function! s:RC.Startup() abort
  let g:VIMRC = s:RC.Init()

  call s:RC.SetPluginEnable()
  call s:RC.LoadPluginConfig()
  syntax enable
  call s:RC.LoadCommand()
  call s:RC.LoadKeyMap()
  call s:RC.LoadLocalrc()
endfunction

call s:RC.Startup()

set secure

