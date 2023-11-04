let g:lightline = {
\ 'enable': { 'statusline': 1, 'tabline': 1 },
\ 'colorscheme': 'powerlineish',
\ 'active': {
\   'left':  [ [ 'mode', 'paste' ],
\              [ 'pwd', 'readonly', 'modified', 'filename' ],
\              [ ] ],
\   'right': [ [ 'lineinfo', 'time' ],
\              [ 'percent' ],
\              [ 'fileformat', 'fileencoding', 'filetype' ] ]
\ },
\ 'separator': { 'left': '', 'right': '' },
\ 'subseparator': { 'left': '', 'right': '' },
\ 'component_function': {
\   'pwd': 'LightLinePwd',
\ }
\}

function! g:LightLinePwd() abort
  return fnamemodify(getcwd(), ':~')
endfunction

