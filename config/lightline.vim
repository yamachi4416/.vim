let g:lightline = {
\ 'enable': { 'statusline': 1, 'tabline': 1 },
\ 'colorscheme': 'solarized',
\ 'active': {
\   'left':  [ [ 'mode', 'paste' ],
\              [ 'fugitive', 'pwd', 'readonly', 'modified', 'filename', 'neomake' ],
\              [ ] ],
\   'right': [ [ 'lineinfo', 'syntastic' ],
\              [ 'percent' ],
\              [ 'fileformat', 'fileencoding', 'filetype' ] ]
\ },
\ 'separator': { 'left': '', 'right': '' },
\ 'subseparator': { 'left': '', 'right': '' },
\ 'component_function': {
\   'neomake': 'neomake#statusline#LoclistStatus',
\   'fugitive': 'LightLineFugitive',
\   'pwd': 'LightLinePwd'
\ }
\}

function! LightLinePwd()
  return fnamemodify(getcwd(), ':~')
endfunction

function! LightLineFugitive()
  if exists('*fugitive#head')
    return fugitive#statusline()
  else
    return ''
  endif
endfunction
