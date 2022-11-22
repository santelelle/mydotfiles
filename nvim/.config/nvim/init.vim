" vim-plug plugin installer
call plug#begin()
  :Plug 'tpope/vim-commentary'
"  :Plug 'tpope/vim-fugitive'
  :Plug 'airblade/vim-gitgutter'
  " Fzf
  :Plug 'junegunn/fzf.vim'
  :Plug 'junegunn/fzf', {'do': { -> fzf#install }}
  :Plug 'tpope/vim-surround'
  :Plug 'sainnhe/gruvbox-material'
  :Plug 'sunjon/shade.nvim'
  " gruvbox
  ":Plug 'morhetx/gruvbox'
call plug#end()

" Colorscheme
if has('termguicolors')
   set termguicolors
endif
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_visual = 'reverse'
colorscheme gruvbox-material

" Sets
set formatoptions=jql
set ignorecase
set smartcase
set autochdir
set updatetime=500
set mouse=a
set undofile
set hidden
set number
set relativenumber
set clipboard=unnamedplus
set signcolumn=yes
set pumheight=8
set pumblend=10
set shortmess+=c
set completeopt+=menuone
set completeopt-=preview
set completeopt+=noselect
set completeopt+=noinsert
set list
set listchars=tab:\|\ ,nbsp:·,trail:·
set noshowcmd
set cursorline
set timeoutlen=300
set scrolloff=1
set shell=/bin/zsh
set foldcolumn=auto:9

" Personal keybindings
let mapleader=','
" disable search when pressing esc
nnoremap <esc> :noh<return><esc>
" use by visual lines
nnoremap j gj
nnoremap k gk
cmap cqf ccl
nnoremap <leader>` :ccl<CR>
nnoremap [q :Cprev<CR>
nnoremap ]q :Cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
" Fzf
nnoremap <C-f> :Files<CR>
nnoremap <leader>f :Lines<CR>
" Save and loading utils
nnoremap <leader>ev :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>sv :source ~/.config/nvim/init.vim<CR>
nnoremap <leader>eb :e ~/.config/bspwm/bspwmrc<CR>
nnoremap <leader>ep :e ~/.config/polybar/config.ini<CR>
nnoremap <leader>es :e ~/.config/sxhkd/sxhkdrc<CR>
nnoremap <leader>ez :e ~/.zshrc<CR>
nnoremap <leader>el :e ~/.config/logid.cfg<CR>
nnoremap <leader>er :e ~/.config/ranger/rc.conf<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>s :w<CR>
" nnoremap <leader>q :bp\|bd#<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>
" change last and next jump keys
nnoremap <C-i> <C-o>z.
nnoremap <C-o> <C-i>z.
nnoremap <C-u> <C-^>
" Folds
nnoremap zz za
nnoremap ]z zj
nnoremap [z zk
" Remove the stupid x storing in the buffer
nnoremap x "_x
" Yank till the end of the line
nnoremap Y y$
" joinlines with H
nnoremap H J
" move up and down one line
nnoremap J j<C-e>
nnoremap K k<C-y>
" move screen down half page
nnoremap <C-K> <C-u>z.
nnoremap <C-J> <C-d>z.
" Moving between splits
nnoremap <C-H> <C-w>h
nnoremap <C-L> <C-w>l
nnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
" move between buffers
nnoremap <silent> <C-N> :bprevious<CR>
nnoremap <silent> <C-M> :bnext<CR>
