" vim-plug plugin installer
call plug#begin()
  " LSP
  :Plug 'neovim/nvim-lspconfig'

  " Treesitter
"  :Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

  " ALE
"  :Plug 'dense-analysis/ale'

  " Auto close brakets
  :Plug 'jiangmiao/auto-pairs'

  " Fzf
  :Plug 'junegunn/fzf.vim'
  :Plug 'junegunn/fzf', {'do': { -> fzf#install }}

  " Completion
  :Plug 'nvim-lua/completion-nvim'

  " Tree folder view
  :Plug 'preservim/nerdtree'

  " Others
  :Plug 'tpope/vim-surround'
  :Plug 'sainnhe/gruvbox-material'
"  :Plug 'tpope/vim-fugitive'
call plug#end()


lua << EOF
  local custom_lsp_attach = function(client)
    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc') 
  end

  require'lspconfig'.pyls.setup{
    -- on_attach = custom_lsp_attach;
    on_attach = require'completion'.on_attach;
    -- completely disable diagnostics
--    handlers = {
--      ["textDocument/publishDiagnostics"] = vim.lsp.with(
--        vim.lsp.diagnostic.on_publish_diagnostics, {
--          -- Disable virtual_text
--          virtual_text = false,
--          -- Disable signs
--          signs = false
--        }
--      ),
--    },
  }
  vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end
--  require'nvim-treesitter.configs'.setup{
--    highlight = {
--      enable = true,
--      use_languagetree = false,
--    },
--  }
EOF

" Word under the cursor highlight
augroup highlight_current_word
  au!
  au CursorHold * :exec 'match Search /\V\<' . expand('<cword>') . '\>/'
augroup END

" linting
let python_provider_script_path = expand('~') . '/.scripts/vim-pythonprovider'
if filereadable(python_provider_script_path)
	let g:python3_host_prog = system(python_provider_script_path)
endif
let g:ale_linters={'python': ['flake8', 'mypy', 'pylint']}
let g:ale_fixers={'python': ['black', 'isort']}
let g:ale_autopep8 = 1
let g:ale_linters_explicit = 1
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_virtualtext_cursor = 1

let g:float_preview#docked = 0
let g:float_preview#max_width = 80
function! DisableExtras()
	call nvim_win_set_option(g:float_preview#win, 'number', v:false)
	call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:false)
	call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)
	call nvim_win_set_option(g:float_preview#win, 'signcolumn', 'no')
endfunction
autocmd User FloatPreviewWinOpen call DisableExtras()

" lsp keybingings
"nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
"nnoremap <silent> <C-k>  <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gk <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0 <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" Folding
autocmd Filetype python setlocal foldmethod=indent foldignore=

" Gruvbox colors
if has('termguicolors')
  set termguicolors
endif
set background=dark
"set background=light
" contrast (hard, medium, soft)
"let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_palette = 'original'
colorscheme gruvbox-material


" Dark/Light toggle
let t:is_dark = 1
function! Toggle_dark_light()
  if t:is_dark == 1
    set background=light
    let t:is_dark = 0
  else
    set background=dark
    let t:is_dark = 1
  endif
endfunction


" Terminal transparency
let t:is_transparent = 0
function! Toggle_transparent_background()
  if t:is_transparent == 0
    hi Normal guibg=#111111 ctermbg=black
    let t:is_transparent = 1
  else
    hi Normal guibg=NONE ctermbg=NONE
    let t:is_transparent = 0
  endif
endfunction


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
"set scrolloff=9999
let g:gruvbox_italic=1

inoremap <silent><expr> <TAB>
	\ <SID>check_back_space() ? "<TAB>" :
	\ pumvisible() ? "<C-n>" : completion#trigger_completion()
"	\ completion#trigger_completion()
"inoremap <silent><expr> <S-TAB> pumvisible() ? "<C-p>" : "<S-TAB>"
inoremap <silent><expr> <Down> pumvisible() ? "<C-n>" : "<Down>"
inoremap <silent><expr> <Up> pumvisible() ? "<C-p>" : "<Up>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Personal keybindings
let mapleader=','
" Commenting
nnoremap gcc mm_i# <ESC>`m
" 
nnoremap <C-f> :Files<CR>
nnoremap <leader>f :Lines<CR>
nnoremap <leader>ev :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>sv :source ~/.config/nvim/init.vim<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>s :w<CR>
nnoremap <leader>q :q<CR>
" change last and next jump keys
nnoremap <C-i> <C-o>z.
nnoremap <C-o> <C-i>z.
" Open splits
nnoremap <leader>v :vsp<CR>
nnoremap <leader>h :sp<CR>
" Fold toggling
nnoremap zz za
" Remove the stupid x storing in the buffer
nnoremap x "_x
" Yank till the end of the line
nnoremap Y y$
" join with H
nnoremap H J
" move up and down one line
nnoremap J j<C-e>
nnoremap K k<C-y>
" move screen down half page
nnoremap <C-K> <C-u>z.
nnoremap <C-J> <C-d>z.
" Moving between splits
nnoremap <C-H> <C-w>h
nnoremap <A-J> <C-w>j
nnoremap <A-K> <C-w>k
nnoremap <C-L> <C-w>l
" Graphics toggling
nnoremap <C-x><C-l> :call Toggle_dark_light()<CR>
nnoremap <C-x><C-t> :call Toggle_transparent_background()<CR>  
" Folder view toggling
nnoremap <leader>n :NERDTreeToggle<CR>
" Move between tabs
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
" current folder terminal launch
map <F7> :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>cd $VIM_DIR<CR>
