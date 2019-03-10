set encoding=utf8
scriptencoding utf-8

if !1 | finish | endif

let s:RC = {'_AUTOCMDS_': {}, '_': {}}

function! s:RC._SetEnv()
  if !has('vim_starting') | return | endif
  let g:skip_defaults_vim = 1
  let $MYVIMFILES  = globpath('~', self.IsWindows ? 'vimfiles' : '.vim')
  let $VIMPLUGDIR  = expand('$MYVIMFILES/bundle/')
  let $VIMCACHEDIR = expand('$MYVIMFILES/cache/')
  if !isdirectory($REFSDIR) | let $REFSDIR = globpath($MYVIMFILES, 'refs') | endif
  if !isdirectory($REFSDIR) | let $REFSDIR = globpath('~', 'refs') | endif
  if exists('&pyxversion')
    set pyxversion=3
  endif
endfunction

function! s:RC._SetStartingVimOptions()
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

function! s:RC._SetEditVimOptions()
  set mouse=a
  set modeline
  set ignorecase smartcase
  if exists('&tagcase')
    set tagcase=match
  endif
  set virtualedit=block backspace=2
  set completeopt=menuone,longest
  set nojoinspaces
  set pastetoggle=<f3>
  set iminsert=0 formatoptions=cqrj nolinebreak
  set copyindent preserveindent
  if exists('&fixendofline')
    set nofixendofline
  endif
  set nospell
  set spelllang=en_us,cjk
endfunction

function! s:RC._SetBufFileVimOptions()
  set isfname& isfname-== isfname-=!
  set hidden
  set wildignorecase wildignore& wildignore+=.git,.hg,.svn
  set tags=tags;
endfunction

function! s:RC._SetDisplayVimOptions()
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
endfunction

function! s:RC._SetCmdAndTermVimOptions()
  set showcmd laststatus=2 cmdwinheight=10 cmdheight=2
  set wildmenu wildmode=longest:full
  set cmdwinheight=5
  if &term =~? '^win' && has('vim_starting')
    set termencoding=cp932
    let $PROMPT = get(v:, 'servername', 'VIM') . ' $P$_$S$G$S'
  endif
endfunction

function! s:RC._SetBackupUndoVimOptions()
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

function! s:RC._DefineGlobalVariables()
  call s:SourceIfExists('$MYVIMFILES/globalvar.vim')
endfunction

function! s:RC._DefineLocalFunctions()
  function! s:SID(...)
    let id = matchstr(string(function('s:SID')), '\C\v\<SNR\>\d+_')
    return a:0 < 1 ? id : id . a:1
  endfunction

  function! s:VimEnter() abort
    if &filetype !=# ''
      exe 'doautocmd filetype' &filetype
    endif
  endfunction

  function! s:AddRefPath(path, paths) abort
    if isdirectory(glob(printf('$REFSDIR/%s', a:path)))
      return join(add(split(a:paths, ','), glob(printf('$REFSDIR/%s', a:path))), ',')
    endif
    return a:path
  endfunction

  function! s:Splitn(str) abort
    return split(a:str, '\v\r\n|\n|\r')
  endfunction

  function! s:WinSplit(cmd) abort
    exe (winwidth(0) * 1.0 / winheight(0) <= 4.0 ? '' : 'vert ') . a:cmd
  endfunction

  function! s:IMode(...) abort
    if pumvisible()       | return get(a:000, 0, '')    | endif
    if &l:omnifunc !=# '' | return "\<C-x>\<C-o>\<C-p>" | endif
    if !empty(tagfiles()) | return "\<C-x>\<C-]>"       | endif
    return "\<C-p>"
  endfunction

  function! s:CreateDictUseSyntax() abort
    if &l:syntax ==# '' | return | endif
    if &l:syntax ==# 'text' | return | endif
    let file = expand('$MYVIMFILES/dict/' . &l:syntax . '.txt')
    if !filereadable(file)
      let words = {}
      for word in syntaxcomplete#OmniSyntaxList() | let words[word] = 0 | endfor
      if writefile(sort(keys(words)), file) == -1
        echoh ErrorMsg | echom 'Error' | echoh Normal | return
      endif
    endif
    tabe `=file`
    nnoremap <buffer><silent><F12> :<C-u>silent keeppatterns g/\v^.?$/d<CR>:%sort u<CR>:wq<CR>
  endfunction

  function! s:ScratchWindow(...) abort
    call s:WinSplit('new')
    setlocal buftype=nofile bufhidden=wipe noswapfile
    if a:0 && type(a:1) is type('') | call append(line('$') - 1, s:Splitn(a:1)) | endif
    if a:0 && type(a:1) is type([]) | call append(line('$') - 1, a:1)           | endif
    keepjumps normal! gg
    nnoremap <buffer><silent><C-l> :<C-u>%d _ <Bar>redraw<CR>
  endfunction

  function! s:IncludeExpr(fname) abort
    let suff = &l:suffixesadd
    let file = fnamemodify(a:fname, ':e') ==# '' ? a:fname . suff : a:fname
    let base = join(add(split(&l:path, ','), get(b:, 'base_path', '')), ',')
    let ret = s:Splitn(globpath(base, file, 0)) + [file]
    if len(ret) == 0
      let ret = glob('./**/' . file)
    endif
    return filereadable(ret[0]) ? ret[0] : v:fname
  endfunction

  function! s:GetFileFromUrl(url, file) abort
    if executable('powershell')
      let command = '(New-Object System.Net.WebClient).DownloadFile(''%s'', ''%s'')'
      let powershell = 'powershell -nologo -command '
      call system(powershell . shellescape(printf(command, a:url, a:file)))
    elseif executable('curl')
      let command = 'curl -fLo %s %s'
      call system(printf(command, shellescape(a:file), a:url))
    endif
  endfunction

  function! s:SourceIfExists(path) abort
    let filepath = expand(a:path)
    if filereadable(filepath)
      source `=filepath`
      return 1
    endif
  endfunction

  function! s:GetSelectText() abort
    let save = @@
    silent normal! gvy
    let [ret, @@] = [@@, save]
    return ret
  endfunction

  function! s:IsInstall(dirname)
    if exists('g:plugs')
      return has_key(g:plugs, a:dirname) || has_key(g:plugs, a:dirname . '.vim')
    endif
    return &runtimepath =~# '\v[\\/]' . a:dirname . ',?'
  endfunction

  function! s:FileTypeAutoCommand()
    setlocal formatoptions-=o cindent
    setlocal complete-=i complete-=t
    if &l:path ==# ''
      setlocal path<
    endif
    if filereadable(expand('$REFSDIR/' . expand('<amatch>') . '/tags'))
      let &l:tags = &tags . ',' . expand('$REFSDIR/' . expand('<amatch>') . '/tags')
    endif
    if filereadable(expand('$MYVIMFILES/dict/' . expand('<amatch>') . '.txt'))
      let &l:dict = glob('$MYVIMFILES/dict/' . expand('<amatch>') . '.txt')
      let &l:complete .= ',k' . &l:dict
    endif
  endfunction

  function! s:QfGitDiff(...)
    let [l:lnum, ret] = [0, []]
    let dir = matchstr(system('git rev-parse --show-toplevel'), '\v^\f+\ze[\r\n]')

    if empty(dir) | return | endif

    for line in split(system(printf('git diff %s', a:0 ? a:1 : '')), '\v\r\n|\n|\r')
      if line[:3] ==# 'diff'
        let [l:lnum, fname] = [0, dir . '/' . matchstr(line, '\v\sb/\zs\f+$')]
        continue
      endif
      let char = line[0]
      if char ==# '@'
        let l:lnum = str2nr(matchstr(line, '\v\+\d+'))
        continue
      endif
      if l:lnum
        if char ==# '+' || char ==# '-'
          call add(ret, {
          \ 'filename': fname, 'type': 'i', 'lnum': l:lnum, 'col': 1, 'text': line})
        endif
        let l:lnum = stridx('-\', char) + 1 ? l:lnum : l:lnum + 1
      endif
    endfor

    call setqflist(ret, 'r')

    if len(ret)
      return 1
    endif
  endfunction

  function s:DelEnv(env_name)
    if !exists('$' . a:env_name)
      return
    endif

    if has('perl')
      silent! exe "perl delete $ENV{'" . a:env_name . "'}"
    elseif has('ruby')
      silent! exe "ruby ENV.delete('" . a:env_name . "')"
    else
      silent! exe 'unlet! $' . a:env_name
    endif
  endfunction

  call extend(self._, {
  \ 'SID': function('s:SID'),
  \ 'IMode': function('s:IMode'),
  \ 'CreateDictUseSyntax': function('s:CreateDictUseSyntax'),
  \ 'ScratchWindow': function('s:ScratchWindow'),
  \ 'IncludeExpr': function('s:IncludeExpr'),
  \ 'GetFileFromUrl': function('s:GetFileFromUrl'),
  \ 'SourceIfExists': function('s:SourceIfExists'),
  \ 'GetSelectText': function('s:GetSelectText'),
  \ 'IsInstall': function('s:IsInstall'),
  \ 'AddRefPath': function('s:AddRefPath'),
  \ 'QfGitDiff': function('s:QfGitDiff'),
  \ 'DelEnv': function('s:DelEnv'),
  \})
endfunction

function! s:RC._InitAutogroup()
  augroup Vimrc
    au!
    au bufnewfile *             setlocal fileencoding=utf8
    au bufnewfile *.{bat,cmd}   setlocal fileencoding=cp932 fileformat=dos
    au bufnewfile,bufreadpost *.jade setlocal filetype=pug
    au filetype *               call s:FileTypeAutoCommand()
    au vimenter * call s:RC._CallRegisterAutoGroups()
    au vimenter * call s:VimEnter()
  augroup END
endfunction

function! s:RC._CallRegisterAutoGroups()
  let obj = self._AUTOCMDS_
  augroup Vimrc
    for prop in keys(obj)
      let F = obj[prop]
      if type(F) is type(function('tr'))
        call call(F, [], obj)
      endif
    endfor
  augroup END
endfunction



function! s:RC.SetVimOptions()
  call self._SetStartingVimOptions()
  call self._SetEditVimOptions()
  call self._SetBufFileVimOptions()
  call self._SetDisplayVimOptions()
  call self._SetCmdAndTermVimOptions()
  call self._SetBackupUndoVimOptions()
endfunction

function! s:RC.SetPluginEnable()
  if !has('vim_starting') | return | endif
  call s:SourceIfExists('$MYVIMFILES/download.vim')
endfunction

function! s:RC.LoadPluginConfig()
  call s:SourceIfExists('$MYVIMFILES/config/plugin.vim')
  for config in split(globpath($MYVIMFILES, '/config/*.vim', 1), "\n")
    if s:IsInstall(matchstr(config, '\vconfig[\/]\zs[^\/]+\ze\.vim'))
      source `=config`
    endif
  endfor
endfunction

function! s:RC.LoadKeyMap()
  call s:SourceIfExists('$MYVIMFILES/mapping.vim')
endfunction

function! s:RC.LoadCommand()
  call s:SourceIfExists('$MYVIMFILES/command.vim')
endfunction

function! s:RC.Init()
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

function! s:RC.LoadLocalrc()
  call s:SourceIfExists('$MYVIMFILES/localrc.vim')
endfunction

let g:VIMRC = s:RC.Init()
call s:RC.SetPluginEnable()
call s:RC.LoadPluginConfig()
call s:RC.LoadCommand()
call s:RC.LoadKeyMap()
call s:RC.LoadLocalrc()

set secure
