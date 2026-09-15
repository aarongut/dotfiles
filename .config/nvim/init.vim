set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set runtimepath+=~/.config/nvim/

lua require('init')
lua require('lsp')
lua require('ask_claude')
