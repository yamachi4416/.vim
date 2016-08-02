nmap <silent><leader><leader> [CtrlPipe]
nmap [CtrlPipe] <Nop>
nmap [CtrlPipe]p <plug>(ctrlp-pipe)
"nnoremap [CtrlPipe]<leader> :<c-u>exe ctrlp#pipe#mapping#getCmd('File/Filer')<cr>
"nnoremap [CtrlPipe]] :<c-u>exe ctrlp#pipe#mapping#getCmd('Line/jump')<cr>
"nnoremap [CtrlPipe]: :<c-u>exe ctrlp#pipe#mapping#getCmd('Vim/cmd')<cr>
"nnoremap [CtrlPipe][ :<c-u>exe ctrlp#pipe#mapping#getCmd('Buffer/ls')<cr>
