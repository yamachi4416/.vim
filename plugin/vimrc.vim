function! s:BuildCommand(cmd, opts, sep) abort
  let l:cmdline = a:cmd
  for l:key in keys(a:opts)
    let l:val = a:opts[l:key]
    let l:cmdline = l:cmdline . ' ' . l:key . a:sep . shellescape(l:val)
  endfor
  return l:cmdline
endfunction

function! s:CreateDictUseSyntax() abort
  if &l:syntax ==# '' || &l:syntax ==# 'text'
    return
  endif

  let l:file = $MYVIMDIR . '/.local/dict/' . &l:syntax . '.txt'
  if !filereadable(l:file)
    let l:words = {}
    for l:word in syntaxcomplete#OmniSyntaxList()
      let l:words[l:word] = 0
    endfor
    if writefile(sort(keys(l:words)), l:file) == -1
      echoh ErrorMsg | echom 'Error' | echoh Normal | return
    endif
  endif

  tabe `=l:file`
  nnoremap <buffer><silent><F12> :<C-u>silent keeppatterns g/\v^.?$/d<CR>:%sort u<CR>:wq<CR>
endfunction
command! -nargs=? CreateDictUseSyntax call s:CreateDictUseSyntax()

command! -nargs=? -bang -complete=function
\ ScratchWindow call vimrc#util#scratch_window(<bang>0 ? eval(<q-args>) : <q-args>)

function! s:ShellOutput(range, cmd) abort
  let l:cmd = a:cmd

  if a:range
    if empty(l:cmd)
      let l:cmd = get(matchlist(getline(1), '\v^#!\s*(.+)'), 1, '')
      if empty(l:cmd)
        throw 'E:ShellOutput: command arg or shebang is required.'
      endif
    endif
    call vimrc#util#scratch_window(vimrc#util#get_select_text())
    execute '1,$!' . l:cmd
    return
  endif

  if empty(l:cmd)
    let l:cmd = expand('%:p')
    if !executable(l:cmd)
      throw 'E:ShellOutput: ' . l:file . 'is not executable.'
    endif
  endif

  call vimrc#util#scratch_window(system(l:cmd))
endfunction

command! -nargs=? -range=0 -complete=shellcmd
\ ShellOutput call s:ShellOutput(<count>, <q-args>)

function! s:GitDiffScrachWindow(...) abort
  let l:opts = a:0 && len(trim(a:1)) > 1 ? shellescape(a:1) : '--cached'
  call s:ShellOutput(0, "git diff " . l:opts)
  setlocal filetype=diff
endfunction
command! -nargs=? GitDiffScrachWindow call s:GitDiffScrachWindow(<q-args>)

function! s:GitGrepQuickfix(search_string) abort
  let l:search_string = a:search_string
  if l:search_string ==# ''
    let l:search_string = expand('<cfile>')
  endif
  let l:command = printf('git grep -n %s', shellescape(l:search_string))
  let l:save_errorformat = &l:errorformat
  let &l:errorformat = '%f:%l%m'
  let l:success = 0
  try
    cgetexpr system(l:command)
    let l:success = 1
  finally
    let &l:errorformat = l:save_errorformat
  endtry
  if l:success && !empty(getqflist())
    copen
  endif
endfunction
command! -nargs=? GitGrepQuickfix call s:GitGrepQuickfix(<q-args>)

function! s:GitLogGraph(...) abort
  let l:opts = a:0 && len(trim(a:1)) > 1 ? ' ' . shellescape(a:1) : ''
  let l:cmdline = s:BuildCommand(
  \'git log --oneline --graph --all', {
  \ '--date': 'short',
  \ '--decorate': 'short',
  \ '--format': "%h\t%ad\t%d\t%s",
  \}, '=') . l:opts
  let l:out = systemlist(l:cmdline)
  call vimrc#util#scratch_window(l:out)
  setlocal filetype=gitrebase
endfunction
command! -nargs=? GitLogGraph call s:GitLogGraph(<q-args>)

function! s:GitShowScrachWindow(...)
  let hash = expand('<cword>')
  if hash =~# '^\v\w+$'
    call vimrc#util#scratch_window(system('git show ' . hash))
    setlocal filetype=gitcommit
  endif
endfunction
command! -nargs=? GitShowScrachWindow call s:GitShowScrachWindow(<q-args>)

function! s:DiffOrigin() abort
  let l:syntax = &l:syntax
  vert new
  let &l:syntax = l:syntax
  setlocal buftype=nofile nobuflisted undolevels=-1
  read ++edit #
  undojoin | 0d_
  diffthis
  wincmd p
  diffthis
endfunction
command! DiffOrig call s:DiffOrigin()

function! s:SetpythonDll() abort
  if !exists('&pythonthreedll') | return | endif
  if executable('python')
    let &pythonthreedll = expand(fnamemodify(exepath('python'), ':p:h') . '/python3?.dll')
  else
    let &pythonthreedll = ''
  endif
endfunction
call s:SetpythonDll()

function! s:StartupTimeLog() abort
  let l:logfile = tempname()
  let l:vim_command = "vim --startuptime %s -c %s"
  let l:start_command = shellescape(printf(':edit %s', l:logfile))
  let l:vim_command = printf(l:vim_command, fnameescape(l:logfile), l:start_command)
  execute '!' . l:vim_command
endfunction
if !has('nvim')
  command! StartupTimeLog call s:StartupTimeLog()
endif

