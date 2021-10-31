let s:_ = g:VIMRC._

let g:no_gvimrc_example = 1

set browsedir=current
set showtabline=2

call s:_.SourceIfExists('$MYVIMFILES/.vim_style.vim')

function s:OptionSet(ret, optname) abort
  let l:opt = '&' . a:optname
  if exists(l:opt)
    let l:val = string(eval(l:opt))
    if !empty(l:val)
      call add(a:ret, printf('let %s = %s', l:opt, l:val))
    endif
  endif
endfunction

command! -nargs=0 SaveWinPosAndFont call s:SaveWinPosAndFont()

function! s:SaveWinPosAndFont() abort
  let l:ret = ['scriptencoding utf-8']

  call add(l:ret, printf('winpos %d %d', getwinposx(), getwinposy()))
  call add(l:ret, printf('colorscheme %s', get(g:, 'colors_name', 'default')))
  for l:name in ['guifont', 'columns', 'lines', 'linespace', 'background', 'cursorline', 'guifontwide', 'renderoptions']
    call s:OptionSet(l:ret, l:name)
  endfor

  call add(l:ret, 'function s:GuiEnter()')
  if exists('&transparency') && &transparency > 0
    call add(l:ret, printf('  let &transparency = %s', &transparency))
  endif
  call add(l:ret, 'endfunction')

  call add(l:ret, 'augroup MYGVIMRC')
  call add(l:ret, '  autocmd!')
  call add(l:ret, '  autocmd guienter * call s:GuiEnter()')
  call add(l:ret, 'augroup END')

  if &enc !=? 'utf-8'
    call map(l:ret, 'iconv(v:val, &enc, ''utf-8'')')
  endif
  call writefile(l:ret, expand('$MYVIMFILES/.vim_style.vim'))
endfunction

