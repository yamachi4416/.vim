let g:quickrun_config = extend(get(g:, 'quickrun_config', {}), {
\ '_': {
\     'runner'                   : 'job',
\     'runner/job/interval'      : 1,
\     'outputter'                : 'error',
\     'outputter/split'          : '%{ winwidth(0) * 1.0 / winheight(0) <= 4.0 ? '''' : ''vert'' }',
\     'outputter/buffer/into'    : 0,
\     'outputter/error/error'    : 'loclist',
\     'outputter/error/success'  : 'buffer',
\ },
\ 'make': {'exec': &makeprg },
\ 'javascript': {
\   'errorformat': ' %# at %m (%f:%l:%c),%f:%l',
\   'hook/eval/template': 'console.log(%s);'
\ },
\ 'cs': { 'type': 'cs/mcs' },
\ 'scss': {'cmdopt': '--style expanded', 'outputter/buffer/filetype': 'quickrun.css'}
\})

nmap <leader>r <Plug>(quickrun)
vmap <leader>r <Plug>(quickrun)
