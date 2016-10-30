nnoremap [ghcmod] <Nop>

function! s:Haskell_Keymap()
  nmap <buffer><silent><leader>j [ghcmod]

  nnoremap [ghcmod]i :<C-u>GhcModInfo<CR>
  nnoremap [ghcmod]j :<C-u>GhcModInfoPreview<CR>
  nnoremap [ghcmod]l :<C-u>GhcModLint<CR>
  nnoremap [ghcmod]t :<C-u>GhcModType<CR>
  nnoremap [ghcmod]y :<C-u>GhcModTypeClear<CR>
  nnoremap [ghcmod]c :<C-u>GhcModCheck<CR>

endfunction

function! g:VIMRC._AUTOCMDS_.GHCMOD()
  au filetype haskell call s:Haskell_Keymap()
endfunction
