function! g:VIMRC._AUTOCMDS_.VIMLSP()
  if executable('pyls')
    augroup LspPython
      au!
      au User lsp_setup call lsp#register_server({
      \ 'name': 'pyls',
      \ 'cmd': {server_info->['pyls']},
      \ 'whitelist': ['python']
      \ })
      au filetype python setlocal omnifunc=lsp#complete
    augroup END
  endif
endfunction
