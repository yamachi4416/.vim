let s:_ = g:VIMRC._

let g:no_gvimrc_example = 1

set browsedir=current
set showtabline=2

call s:_.SourceIfExists('$MYVIMFILES/.vim_style.vim')

function s:OptionSet(ret, optname)
  let opt = '&' . a:optname
  if exists(opt)
    let val = string(eval(opt))
    if !empty(val)
      call add(a:ret, printf('let %s = %s', opt, val))
    endif
  endif
endfunction

command! -nargs=0 SaveWinPosAndFont call s:SaveWinPosAndFont()

function! s:SaveWinPosAndFont()
  let ret = ['scriptencoding utf-8']

  call add(ret, printf('winpos %d %d', getwinposx(), getwinposy()))
  call add(ret, printf('colorscheme %s', get(g:, 'colors_name', 'default')))
  for name in ['guifont', 'columns', 'lines', 'linespace', 'background', 'cursorline', 'guifontwide', 'renderoptions']
    call s:OptionSet(ret, name)
  endfor

  call add(ret, 'function s:GuiEnter()')
  if exists('&transparency') && &transparency > 0
    call add(ret, printf('  let &transparency = %s', &transparency))
  endif
  call add(ret, 'endfunction')

  call add(ret, 'augroup MYGVIMRC')
  call add(ret, '  autocmd!')
  call add(ret, '  autocmd guienter * call s:GuiEnter()')
  call add(ret, 'augroup END')

  if &enc !=? 'utf-8'
    call map(ret, 'iconv(v:val, &enc, ''utf-8'')')
  endif
  call writefile(ret, expand('$MYVIMFILES/.vim_style.vim'))
endfunction
