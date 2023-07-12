""
"" midir.vim
""
"" Made by Pablo Alessandro Santos Hugen
"" Email: pablohuggem@gmail.com
""

" This file is used to detect the midir files

" INSTALL instructions:
" $ mkdir -p ~/.vim/ftdetect
" $ cp midir-ftdetect.vim ~/.vim/ftdetect/tiger.vim

au BufRead,BufNewFile *.mi		set filetype=midir
au BufRead,BufNewFile *.mih		set filetype=midir
