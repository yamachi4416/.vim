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
\ 'scss' : {'cmdopt': '--style expanded', 'outputter/buffer/filetype': 'quickrun.css'}
\})

let s:outputter = {
\ 'kind': 'outputter',
\ 'name': 'scratchpad',
\ 'config': { 'cmstr': '', 'normcmd': '', 'pad': '', 'regname': 'y', 'action': '' }
\}

function! s:outputter.init(session) abort
  let config = self.config
  let config.cmstr = config.cmstr ==# '' ? &l:commentstring : '%s'
endfunction

function! s:outputter.output(data, session) abort
  let cmstr = self.config.cmstr
  let action = self.config.action
  let regname = self.config.regname
  let padcnt = self.config.pad

  if action ==# 'after'
    let cmd = "`>o\e\"" . regname . 'p`>'
  elseif action ==# 'line'
    let cmd = "`>A\e\"" . regname . 'pg;'
    if padcnt ==# '' | let padcnt = '1' | endif
  else
    let cmd = self.config.normcmd
  endif

  let cmstr = repeat(' ', padcnt) . cmstr
  call setreg(regname, join(map(split(a:data, '\v\r\n|\n|\r'), 'printf(cmstr, v:val)'), "\n"))
  if cmd !=# '' | exe 'normal!' cmd | endif
endfunction

call quickrun#module#register(deepcopy(s:outputter))

vnoremap <silent><Plug>(quickrun-scratchpad-after)
\ :<C-u>QuickRun -mode v -outputter scratchpad -outputter/scratchpad/action after<CR>

nnoremap <silent><Plug>(quickrun-scratchpad-line)
\ :<C-u>normal V<CR>:<C-u>QuickRun -mode v -outputter scratchpad
\ -outputter/scratchpad/action line<CR>

nnoremap <silent><Plug>(quickrun-scratchpad-evalline)
\ :<C-u>normal V<CR>:<C-u>QuickRun -mode v -outputter scratchpad
\ -hook/eval/enable 1
\ -outputter/scratchpad/action line<CR>



vmap <leader>l <Plug>(quickrun-scratchpad-after)
nmap <leader>l <Plug>(quickrun-scratchpad-line)
nmap <leader>; <Plug>(quickrun-scratchpad-evalline)

nmap <leader>r <Plug>(quickrun)
vmap <leader>r <Plug>(quickrun)
