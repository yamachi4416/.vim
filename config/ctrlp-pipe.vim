nmap <Leader>p <plug>(ctrlp-pipe)
nnoremap <silent><leader><leader> :<c-u>exe ctrlp#pipe#mapping#getCmd('File/Filer')<cr>
nnoremap <silent><leader>] :<c-u>exe ctrlp#pipe#mapping#getCmd('Line/jump')<cr>
nnoremap <silent><leader>: :<c-u>exe ctrlp#pipe#mapping#getCmd('Vim/cmd')<cr>
nnoremap <silent><leader>[ :<c-u>exe ctrlp#pipe#mapping#getCmd('Buffer/ls')<cr>
