let s:_ = g:VIMRC._

set browsedir=current
set showtabline=2
call s:_.SourceIfExists('$MYVIMFILES/.vim_style.vim')

command! -nargs=0 SaveWinPosAndFont call s:SaveWinPosAndFont()

function! s:SaveWinPosAndFont()
  let ret = ['scriptencoding utf-8']
  for name in ['guifont', 'columns', 'lines', 'linespace', 'background', 'cursorline']
    let opt = '&' . name
    if exists(opt)
      let val = string(eval(opt))
      if !empty(val)
        call add(ret, printf('let %s = %s', opt, val))
      endif
    endif
  endfor
  call add(ret, printf('winpos %d %d', getwinposx(), getwinposy()))
  call add(ret, printf('colorscheme %s', get(g:, 'colors_name', 'default')))
  if exists('&transparency') && &transparency > 0
    call add(ret, printf('let &transparency = %s', &transparency))
  endif
  if &enc !=? 'utf-8'
    call map(ret, 'iconv(v:val, &enc, ''utf-8'')')
  endif
  call writefile(ret, expand('$MYVIMFILES/.vim_style.vim'))
endfunction
