let g:lightline = {
\ 'enable': { 'statusline': 1, 'tabline': 1 },
\ 'colorscheme': 'PaperColor',
\ 'active': {
\   'left': [['mode'], ['readonly', 'filename', 'modified']],
\   'right': [ [ 'lineinfo', 'syntastic' ],
\              [ 'percent' ],
\              [ 'fileformat', 'fileencoding', 'filetype' ] ]
\ },
\ 'separator': { 'left': '', 'right': '' },
\ 'subseparator': { 'left': '', 'right': '' },
\ 'component_function': {
\   'syntastic': 'SyntasticStatuslineFlag',
\ }
\}
