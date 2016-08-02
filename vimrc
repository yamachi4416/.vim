set encoding&vim
scriptencoding utf-8

if !1 | finish | endif

let s:RC = {'_AUTOCMDS_': {}, '_': {}}

function! s:RC._SetEnv()
  if !has('vim_starting') | return | endif
  let $MYVIMFILES  = globpath('~', self.IsWindows ? 'vimfiles' : '.vim')
  let $VIMPLUGDIR  = expand('$MYVIMFILES/bundle/')
  let $VIMCACHEDIR = expand('$MYVIMFILES/cache/')
  let $MYVIMINFO   = $MYVIMFILES . '/' . (has('nvim') ? '.nviminfo' : '.viminfo')
  if !isdirectory($REFSDIR) | let $REFSDIR = globpath($MYVIMFILES, 'refs') | endif
  if !isdirectory($REFSDIR) | let $REFSDIR = globpath('~', 'refs') | endif
endfunction
function! s:RC._SetStartingVimOptions()
  if !has('vim_starting') | return | endif
  set nobomb
  set fileencoding=
  set fileencodings=ucs-bom,utf8,sjis,cp932,eucjp,default,latin
  set fileformat=
  set fileformats=unix,dos
  set helplang=ja,en
  set autoread
  set novisualbell noerrorbells
  set clipboard& clipboard+=unnamed
  set softtabstop=-1 shiftwidth=0 tabstop=2 expandtab
endfunction
function! s:RC._SetEditVimOptions()
  set mouse=a
  set modeline
  set ignorecase infercase
  set virtualedit=block backspace=2
  set completeopt=menuone,longest
  set nojoinspaces
  set iminsert=0 formatoptions=cqrj nolinebreak
  set copyindent preserveindent
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
  set whichwrap=[,],<,>
  set number relativenumber ruler
  set textwidth=80 colorcolumn=80
  set synmaxcol=0
  set noequalalways scrolloff=0 splitright splitbelow
  set sidescroll=1 sidescrolloff=1
  set foldopen& foldopen-=block foldopen+=jump foldlevelstart=99
  set foldlevel=99 foldminlines=0 foldmethod=indent
  set cursorline cursorcolumn
  if exists('&breakindent')
    set wrap breakindent
    set breakindentopt& breakindentopt+=shift:4
  else
    set nowrap
  endif
  let &g:statusline =
  \ ' %{pathshorten(getcwd())} %{expand(''%'')} %m%r%w %=%{join([&fenc,&ff])} '
  set guioptions=ecM
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
  set history=100 viminfo='100,h,f20,<0,s0,c,n$MYVIMINFO
  if has('persistent_undo')
    if !isdirectory($MYVIMFILES . '/undo')
      call mkdir(expand($MYVIMFILES . '/undo'))
    endif
    set undofile undodir=$MYVIMFILES/undo
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
    if &ft !=# ''
      exe 'doautocmd filetype' &ft
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
    setl buftype=nofile bufhidden=hide noswapfile nobuflisted
    if a:0 && type(a:1) is type('') | call append(line('$') - 1, s:Splitn(a:1)) | endif
    if a:0 && type(a:1) is type([]) | call append(line('$') - 1, a:1)           | endif
    keepjumps normal! gg
    nnoremap <buffer><silent><C-l> :<C-u>%d _ <Bar>redraw<CR>
  endfunction
  function! s:RubyAddBundlePaths() abort
    if !has('ruby') || !executable('bundle') | return | endif
    let g:rubycomplete_gemfile_path = findfile('Gemfile', expand(expand('%:p:h').'/;'))
    let g:rubycomplete_use_bundler = g:rubycomplete_gemfile_path ==# '' ? 0 : 1
    if g:rubycomplete_use_bundler == 0 | return | endif
    let l:path = split(&l:path, ',')
ruby << EOF
begin
  require 'bundler'
  VIM::command('let l:path += %s' % Bundler.bundle_path.join('gems').children.map{|p; path|
    $LOAD_PATH << path unless $LOAD_PATH.include?(path = p.join('lib').to_s); path
  }.inspect)
rescue LoadError => e
  VIM::command('echom "%s"' % e.message)
end
EOF
    let &l:path = join(uniq(l:path), ',')
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
      let command = '(New-Object System.Net.WebClient).downloadFile(''%s'', ''%s'')'
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
    return &rtp =~# '\v[\\/]' . a:dirname . ',?'
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
  \ 'IsInstall': function('s:IsInstall')
  \})
endfunction
function! s:RC._InitAutogroup()
  augroup Vimrc
    au!
    au bufnewfile *             setl fileencoding=utf8
    au bufnewfile *.{bat,cmd}   setl fileencoding=cp932 fileformat=dos
    au bufnewfile,bufreadpost *.jade setl filetype=pug
    au filetype *               setl formatoptions-=o cindent
    au filetype vim             setl keywordprg=:help foldmethod=syntax
    au filetype css,scss,less   setl iskeyword+=-
    au filetype html,xhtml,jsp  setl iskeyword+=-
    \|  if exists('b:match_words')
    \|    setl matchpairs-=<:>
    \|    let b:match_words = substitute(b:match_words, '\V<:>,', '', 'g')
    \|  endif
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
function! s:RC.RegisterAutoCmd(callObj)
  call extend(self._AUTOCMDS_, a:callObj)
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
  let self.Omni = {'sql' : ''}
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

function! s:RC._AUTOCMDS_.Include()
  au filetype * if &l:path ==# '' | setl path< | endif

  au filetype *
  \   if filereadable(expand('$REFSDIR/' . expand('<amatch>') . '/tags'))
  \|    let &l:tags = &tags . ',' . expand('$REFSDIR/' . expand('<amatch>') . '/tags')
  \|  endif

  au filetype ruby
  \   let &l:include = '\v<require\s*\(?\s*([''"])\zs\f+\ze\1?\)?$'
  \|  let &l:includeexpr = s:SID('IncludeExpr(v:fname)')
  \|  call s:RubyAddBundlePaths()

  au filetype java
  \   let &l:path        = s:AddRefPath('java/src', &l:path)
  \|  let &l:includeexpr = s:SID('IncludeExpr(tr(v:fname,''.'',''/''))')
  \|  let &l:include     = '\v^import\s+'
  \|  let &l:suffixesadd = '.java'

  au filetype javascript
  \   let &l:include = '\v<require\s*\(\s*([''"])\zs\f+\ze\1?\)'
  \|  let &l:suffixesadd = '.js'
  \|  let &l:path        = s:AddRefPath('javascript/node/lib', &l:path)
  \|  let &l:includeexpr = s:SID('IncludeExpr(v:fname)')
endfunction
function! s:RC._AUTOCMDS_.Complete()
  au filetype * setl complete-=i complete-=t
  au filetype * let &l:ofu = get(s:RC.Omni, expand('<amatch>'), &l:ofu)

  au filetype *
  \   if filereadable(expand('$MYVIMFILES/dict/' . expand('<amatch>') . '.txt'))
  \|    let &l:dict = glob('$MYVIMFILES/dict/' . expand('<amatch>') . '.txt')
  \|    let &l:complete .= ',k' . &l:dict
  \|  endif

  au filetype eruby let &l:ofu = b:eruby_subtype =~ 'html' ? 'htmlcomplete#CompleteTags' : &l:ofu
  au filetype jst   let &l:ofu = 'htmlcomplete#CompleteTags'
endfunction

let VIMRC = s:RC.Init()
call s:RC.SetPluginEnable()
call s:RC.LoadPluginConfig()
call s:RC.LoadCommand()
call s:RC.LoadKeyMap()
call s:RC.LoadLocalrc()

set secure
