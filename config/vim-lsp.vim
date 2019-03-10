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

  if executable('clangd')
    augroup LspClangd
      au!
      au User lsp_setup call lsp#register_server({
      \ 'name': 'clangd',
      \ 'cmd': {server_info->['clangd']},
      \ 'whitelist': ['c', 'cpp'],
      \ })
      au filetype c,cpp setlocal omnifunc=lsp#complete
    augroup END
  endif

  if executable('solargraph')
    augroup LspSolagraph
      au!
      au User lsp_setup call lsp#register_server({
      \ 'name': 'solargraph',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
      \ 'initialization_options': {'diagnostics': 'true'},
      \ 'whitelist': ['ruby'],
      \ })
      au filetype ruby setlocal omnifunc=lsp#complete
    augroup END
  endif
endfunction
