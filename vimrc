set encoding=utf8
scriptencoding utf-8

if !1 | finish | endif

let s:RC = {'_': {}}

function! s:RC._SetEnv() abort
  if !has('vim_starting') | return | endif

  let $MYVIMFILES  = expand('<script>:p:h')
  let $VIMPLUGDIR  = expand('$MYVIMFILES/.local/plugs')
  let $VIMCACHEDIR = expand('$MYVIMFILES/.local/cache')

  if self.IsNvim
    set runtimepath^=$MYVIMFILES
    set runtimepath+=$MYVIMFILES/after
    let &packpath = &runtimepath
  endif

  if exists('&pyxversion')
    set pyxversion=3
  endif

  let l:path_sep = self.IsWindows ? ';' : ':'
  let l:paths = split($PATH, l:path_sep)

  if self.IsWindows && isdirectory(expand('$SCOOP'))
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

function! s:RC._SetStartingVimOptions() abort
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

function! s:RC._SetEditVimOptions() abort
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

function! s:RC._SetBufFileVimOptions() abort
  set isfname& isfname-== isfname-=!
  set hidden
  set wildignorecase wildignore&
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
  set showtabline=2
  if exists(':sign')
    set signcolumn=yes
  endif
endfunction

function! s:RC._SetCmdAndTermVimOptions() abort
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

function! s:RC._SetBackupUndoVimOptions() abort
  set nobackup nowritebackup noswapfile
  set history=100 viminfo-=!

  if self.IsNvim
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

  function! s:WinSplit(cmd, name) abort
    let l:wincmd = (winwidth(0) * 1.0 / winheight(0) <= 4.0 ? '' : 'vert ') . a:cmd
    if empty(a:name)
      execute l:wincmd
    else
      execute printf('%s %s', a:cmd, fnameescape(a:name))
    endif
  endfunction

  function! s:IMode(...) abort
    if pumvisible()
      return get(a:000, 0, '')
    elseif &l:omnifunc !=# ''
      return "\<C-x>\<C-o>"
    elseif !empty(tagfiles())
      return "\<C-x>\<C-]>"
    endif
    return "\<C-p>"
  endfunction

  function! s:ScratchWindowWithName(name, args) abort
    call s:WinSplit('new', a:name)
    setlocal buftype=nofile bufhidden=wipe noswapfile
    if len(a:args)
      let l:arg = a:args[0]
      if type(l:arg) is type('')
        call append(line('$') - 1, s:Splitn(l:arg))
      elseif type(l:arg) is type([])
        call append(line('$') - 1, l:arg)
      endif
    endif
    keepjumps normal! gg
    nnoremap <buffer><silent><C-l> :<C-u>%d _ <Bar>redraw<CR>
  endfunction

  function! s:ScratchWindow(...) abort
    call s:ScratchWindowWithName('', a:000)
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
      let l:powershell .= ' -NoLog -NoProfile -ExecutionPolicy RemoteSigned -Command '
      let l:command = '(New-Object System.Net.WebClient).DownloadFile(''%s'', ''%s'')'
      call system(l:powershell . shellescape(printf(l:command, a:url, a:file)))
    elseif executable('curl')
      let l:command = 'curl -fLo %s %s'
      call system(printf(l:command, shellescape(a:file), a:url))
    endif
  endfunction

  function! s:ExpandPath(path) abort
    let l:wildignore = &wildignore
    try
      set wildignore=
      return expand(a:path)
    finally
      let &wildignore = l:wildignore
    endtry
  endfunction

  function! s:SourceIfExists(path) abort
      let l:filepath = s:ExpandPath(a:path)
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

  function! s:IsInstalled(name) abort
    if exists('g:plugs')
      return has_key(g:plugs, a:name) ||
      \ has_key(g:plugs, a:name . '.vim') ||
      \ has_key(g:plugs, a:name . '.nvim')
    endif
    return &runtimepath =~# '\v[\\/]' . a:name . ',?'
  endfunction

  function! s:FileTypeAutoCommand() abort
    let l:filetype = expand('<amatch>')
    setlocal formatoptions-=o
    setlocal smartindent
    setlocal complete-=i complete-=t
    if &l:path ==# ''
      setlocal path<
    endif
    let l:dict = $MYVIMFILES .'/.local/dict/' . l:filetype . '.txt'
    if filereadable(l:dict)
      execute 'setlocal dict+=' . l:dict
      execute 'setlocal complete+=k' . l:dict
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
  \ 'ScratchWindowWithName': function('s:ScratchWindowWithName'),
  \ 'ScratchWindow': function('s:ScratchWindow'),
  \ 'IncludeExpr': function('s:IncludeExpr'),
  \ 'GetFileFromUrl': function('s:GetFileFromUrl'),
  \ 'ExpandPath': function('s:ExpandPath'),
  \ 'SourceIfExists': function('s:SourceIfExists'),
  \ 'GetSelectText': function('s:GetSelectText'),
  \ 'IsInstalled': function('s:IsInstalled'),
  \ 'DelEnv': function('s:DelEnv'),
  \})
endfunction

function! s:RC._InitAutogroup() abort
  augroup Vimrc
    autocmd!
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
  if self.IsNvim
    call s:SourceIfExists('$MYVIMFILES/config/plugin.lua')
  endif

  for l:config in split(globpath($MYVIMFILES, 'config/*', 1), "\n")
    let l:fname = matchstr(l:config, '\vconfig[\/]\zs[^\/]+$')
    let l:ext = get(split(l:fname, '\v\ze\.'), -1, '')
    let l:name = slice(l:fname, 0, len(l:fname) - len(l:ext))

    if !self.IsNvim && l:ext !=# '.vim'
      continue
    endif

    if s:IsInstalled(l:name)
      source `=l:config`
    endif
  endfor
endfunction

function! s:RC.LoadKeyMap() abort
  call s:SourceIfExists('$MYVIMFILES/mapping.vim')
endfunction

function! s:RC.LoadMenu() abort
  call s:SourceIfExists('$MYVIMFILES/menu.vim')
endfunction

function! s:RC.LoadCommand() abort
  call s:SourceIfExists('$MYVIMFILES/command.vim')
endfunction

function! s:RC.Init() abort
  let self.IsWindows = has('win32')
  let self.IsUnix = has('unix')
  let self.IsNvim = has('nvim')
  call self._DefineLocalFunctions()
  call self._SetEnv()
  call s:SourceIfExists('$MYVIMFILES/.local/vimrc.vim')
  call self._DefineGlobalVariables()
  call self._InitAutogroup()
  call self.SetVimOptions()
  return self
endfunction

function! s:RC.LoadLocalrc() abort
  call s:SourceIfExists('$MYVIMFILES/.local/vimrc.vim')
endfunction

function! s:RC.LoadedEnd() abort
  let &wildignore = '*/.git/*,*/node_modules/*,' . $VIMCACHEDIR . '/*'
  set secure
endfunction

function! s:RC.Startup() abort
  let self.IsLoaded = 0
  let g:VIMRC = s:RC.Init()

  call self.SetPluginEnable()
  call self.LoadPluginConfig()

  syntax enable
  call self.LoadCommand()
  call self.LoadKeyMap()
  call self.LoadMenu()

  let self.IsLoaded = 1
  call self.LoadLocalrc()

  set secure
endfunction

call s:RC.Startup()
