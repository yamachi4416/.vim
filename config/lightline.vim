let g:lightline = {
\ 'enable': { 'statusline': 1, 'tabline': 1 },
\ 'colorscheme': 'solarized',
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
\   'time': 'LightLineTime',
\ }
\}

function! LightLinePwd()
  return fnamemodify(getcwd(), ':~')
endfunction

function! LightLineTime()
  return strftime('%H:%M')
endfunction

