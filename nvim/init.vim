" vim-plug plugin installer
call plug#begin()

" LSP
:Plug 'neovim/nvim-lspconfig'

" Treesitter
:Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

call plug#end()

lua << EOF
require'lspconfig'.pyright.setup{}
