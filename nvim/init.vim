" vim-plug plugin installer
call plug#begin()
  " LSP
  :Plug 'neovim/nvim-lspconfig'

  " commenting
  :Plug 'tpope/vim-commentary'

  " Treesitter
  :Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
"  :Plug 'nvim-treesitter/playground'

  " ALE
  :Plug 'dense-analysis/ale'

  " Auto close brakets
  :Plug 'jiangmiao/auto-pairs'

  " Highlighting same word
  :Plug 'RRethy/vim-illuminate'

  " Fzf
  :Plug 'junegunn/fzf.vim'
  :Plug 'junegunn/fzf', {'do': { -> fzf#install }}

  " Completion
  :Plug 'nvim-lua/completion-nvim'

  " Git signs on the left bar
  :Plug 'airblade/vim-gitgutter'

  " Tree folder view
  :Plug 'preservim/nerdtree'

  " Undotree
  :Plug 'mbbill/undotree'

  " Statusbar
  :Plug 'vim-airline/vim-airline'

  " Git
  :Plug 'tpope/vim-fugitive'

  " Others
  :Plug 'tpope/vim-surround'
  :Plug 'sainnhe/gruvbox-material'
call plug#end()

lua << EOF
--  local custom_lsp_attach = function(client)
--    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc') 
--  end

  require'lspconfig'.pyls.setup{
    -- on_attach = custom_lsp_attach;
    -- on_attach = require'completion'.on_attach;
    on_attach = function(client)
      require'completion'.on_attach(client)
      require'illuminate'.on_attach(client)
    end,
  }
  -- completely disable diagnostics
  vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end

  require'nvim-treesitter.configs'.setup{
    highlight = {
      enable = true,
      use_languagetree = false,
    },
--    playground = {
--      enable = true,
--      updatetime = 25,
--      persist_queries = false,
--    },
  }
EOF

" AUTOSTORE VIEW
let g:skipview_files = ['[EXAMPLE PLUGIN BUFFER]']
function! MakeViewCheck()
    if has('quickfix') && &buftype =~ 'nofile'
        " Buffer is marked as not a file
        return 0
    endif
    if empty(glob(expand('%:p')))
        " File does not exist on disk
        return 0
    endif
    if len($TEMP) && expand('%:p:h') == $TEMP
        " We're in a temp dir
        return 0
    endif
    if len($TMP) && expand('%:p:h') == $TMP
        " Also in temp dir
        return 0
    endif
    if index(g:skipview_files, expand('%')) >= 0
        " File is in skip list
        return 0
    endif
    return 1
endfunction

function! LoadView() abort
   try
       loadview
   catch /E484/
       return
   endtry
endfunction

augroup vimrcAutoView
    autocmd!
    " Autosave & Load Views.
    autocmd BufWritePost,BufLeave,WinLeave ?* if MakeViewCheck() | mkview | endif
    autocmd BufWinEnter ?* if MakeViewCheck() | silent call LoadView() | endif
augroup end

" linting
"let python_provider_script_path = expand('~') . '/.scripts/vim-pythonprovider'
"if filereadable(python_provider_script_path)
"	let g:python3_host_prog = system(python_provider_script_path)
"endif
let g:ale_linters={'python': ['flake8']}
" let g:ale_linters={'python': ['flake8', 'mypy', 'pylint']}
"let g:ale_fixers={'python': ['black', 'isort']}
"let g:ale_autopep8 = 1
"let g:ale_linters_explicit = 1
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
"let g:ale_virtualtext_cursor = 1

"let g:float_preview#docked = 0
"let g:float_preview#max_width = 80
"function! DisableExtras()
"	call nvim_win_set_option(g:float_preview#win, 'number', v:false)
"	call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:false)
"	call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)
"	call nvim_win_set_option(g:float_preview#win, 'signcolumn', 'no')
"endfunction
"autocmd User FloatPreviewWinOpen call DisableExtras()

" Lsp keybingings
"nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>z.
"nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
"nnoremap <silent> <C-k>  <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gk <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0 <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" Gruvbox colors
if has('termguicolors')
  set termguicolors
endif

function! Toggle_gruvbox_line_highlight()
if get(g:, 'gruvbox_material_diagnostic_line_highlight') == 0
    echo 'enabling line highlight'
    let g:gruvbox_material_diagnostic_line_highlight = 1
    colorscheme gruvbox-material
  else
    echo 'disabling line highlight'
    let g:gruvbox_material_diagnostic_line_highlight = 0
    colorscheme gruvbox-material
  endif
endfunction

function! Toggle_transparent()
  if get(g:, 'gruvbox_material_transparent_background') == 0
    let g:gruvbox_material_transparent_background = 1
    colorscheme gruvbox-material
  else
    let g:gruvbox_material_transparent_background = 0
    colorscheme gruvbox-material
  endif
endfunction

let t:is_dark = 1
function! Toggle_dark_light()
  if t:is_dark == 1
    echo 'setting light'
    let t:is_dark = 0
    let g:gruvbox_material_palette = t:my_light_palette
    colorscheme gruvbox-material
  else
    echo 'setting dark'
    let t:is_dark = 1
    let g:gruvbox_material_palette = t:my_dark_palette
    colorscheme gruvbox-material
  endif
endfunction

let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_visual = 'reverse'
let t:my_light_palette = {
    \ 'bg0':              ['#f9f5d7',   '230'],
    \ 'bg1':              ['#f5edca',   '229'],
    \ 'bg2':              ['#f3eac7',   '229'],
    \ 'bg3':              ['#f2e5bc',   '228'],
    \ 'bg4':              ['#eee0b7',   '223'],
    \ 'bg5':              ['#ebdbb2',   '223'],
    \ 'bg_statusline1':   ['#f5edca',   '223'],
    \ 'bg_statusline2':   ['#f3eac7',   '223'],
    \ 'bg_statusline3':   ['#eee0b7',   '250'],
    \ 'bg_diff_green':    ['#e3f6b4',   '194'],
    \ 'bg_visual_green':  ['#dde5c2',   '194'],
    \ 'bg_diff_red':      ['#ffdbcc',   '217'],
    \ 'bg_visual_red':    ['#f6d2ba',   '217'],
    \ 'bg_diff_blue':     ['#cff1f6',   '117'],
    \ 'bg_visual_blue':   ['#d9e1cc',   '117'],
    \ 'bg_visual_yellow': ['#f1e2b7',   '226'],
    \ 'bg_current_word':  ['#e3dab7',   '229'],
    \ 'fg0':              ['#3c3836',   '237'],
    \ 'fg1':              ['#3c3836',   '237'],
    \ 'red':              ['#9d0006',   '88'],
    \ 'orange':           ['#af3a03',   '130'],
    \ 'yellow':           ['#b57614',   '136'],
    \ 'green':            ['#79740e',   '100'],
    \ 'aqua':             ['#427b58',   '165'],
    \ 'blue':             ['#076678',   '24'],
    \ 'purple':           ['#8f3f71',   '96'],
    \ 'bg_red':           ['#ae5858',   '88'],
    \ 'bg_green':         ['#6f8352',   '100'],
    \ 'bg_yellow':        ['#a96b2c',   '130'],
    \ 'grey0':            ['#a89984',   '246'],
    \ 'grey1':            ['#928374',   '245'],
    \ 'grey2':            ['#7c6f64',   '243'],
    \ 'none':             ['NONE',      'NONE']
    \ }
let t:my_dark_palette = {
    \ 'bg0':              ['#1d2021',   '234'],
    \ 'bg1':              ['#282828',   '235'],
    \ 'bg2':              ['#282828',   '235'],
    \ 'bg3':              ['#3c3836',   '237'],
    \ 'bg4':              ['#3c3836',   '237'],
    \ 'bg5':              ['#504945',   '239'],
    \ 'bg_statusline1':   ['#282828',   '235'],
    \ 'bg_statusline2':   ['#32302f',   '235'],
    \ 'bg_statusline3':   ['#504945',   '239'],
    \ 'bg_diff_green':    ['#32361a',   '22'],
    \ 'bg_visual_green':  ['#333e34',   '22'],
    \ 'bg_diff_red':      ['#3c1f1e',   '52'],
    \ 'bg_visual_red':    ['#442e2d',   '52'],
    \ 'bg_diff_blue':     ['#0d3138',   '17'],
    \ 'bg_visual_blue':   ['#2e3b3b',   '17'],
    \ 'bg_visual_yellow': ['#473c29',   '94'],
    \ 'bg_current_word':  ['#62606f',   '236'],
    \ 'fg0':              ['#ebdbb2',   '223'],
    \ 'fg1':              ['#ebdbb2',   '223'],
    \ 'red':              ['#fb4934',   '167'],
    \ 'orange':           ['#fe8019',   '208'],
    \ 'yellow':           ['#fabd2f',   '214'],
    \ 'green':            ['#b8bb26',   '142'],
    \ 'aqua':             ['#8ec07c',   '108'],
    \ 'blue':             ['#83a598',   '109'],
    \ 'purple':           ['#d3869b',   '175'],
    \ 'bg_red':           ['#cc241d',   '124'],
    \ 'bg_green':         ['#b8bb26',   '106'],
    \ 'bg_yellow':        ['#fabd2f',   '172'],
    \ 'grey0':            ['#7c6f64',   '243'],
    \ 'grey1':            ['#928374',   '245'],
    \ 'grey2':            ['#a89984',   '246'],
    \ 'none':             ['NONE',     'NONE']
    \ }
let g:gruvbox_material_palette = t:my_dark_palette
colorscheme gruvbox-material

" Folding
autocmd Filetype python setlocal foldmethod=indent foldignore=

" Sets
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
set formatoptions=jcrql
set timeoutlen=300
set scrolloff=20


function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
	\ <SID>check_back_space() ? "<TAB>" :
	\ pumvisible() ? "<C-n>" : completion#trigger_completion()
"	\ completion#trigger_completion()
"inoremap <silent><expr> <S-TAB> pumvisible() ? "<C-p>" : "<S-TAB>"
inoremap <silent><expr> <Down> pumvisible() ? "<C-n>" : "<Down>"
inoremap <silent><expr> <Up> pumvisible() ? "<C-p>" : "<Up>"

" Personal keybindings
let mapleader=','
" Quick fix stuff
command! Cnext try | cnext | catch | cfirst | catch | endtry
command! Cprev try | cprev | catch | clast | catch | endtry
cmap cqf ccl
nnoremap <leader>` :ccl<CR>
nnoremap [q :Cprev<CR>
nnoremap ]q :Cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
" Gitgutter
let g:gitgutter_sign_added = '🥒'
let g:gitgutter_sign_modified = '🥔'
let g:gitgutter_sign_removed = '🍉'
let g:gitgutter_map_keys = 0
nmap <leader>g <Plug>(GitGutterPreviewHunk)
nmap <leader>gg <Plug>(GitGutterUndoHunk)
" nmap <leader>gs <Plug>(GitGutterStageHunk)
nmap <leader>gh :GitGutterLineHighlightsToggle<CR>
nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)
nmap zg :GitGutterFold<CR>
" Fzf
nnoremap <C-f> :Files<CR>
nnoremap <leader>f :Lines<CR>
" Save and loading utils
nnoremap <leader>ev :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>sv :source ~/.config/nvim/init.vim<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>s :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>
" change last and next jump keys
nnoremap <C-i> <C-o>z.
nnoremap <C-o> <C-i>z.
nnoremap <C-u> <C-^>
" Undotree
nnoremap <leader>u :UndotreeToggle<CR>
" Fold toggling
nnoremap zz za
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
" Graphics toggling
nnoremap <leader>b :call Toggle_dark_light()<CR>
nnoremap <leader>t :call Toggle_transparent()<CR>
nnoremap <leader>h :call Toggle_gruvbox_line_highlight()<CR>
" Folder view toggling
nnoremap <C-n> :NERDTreeToggle<CR>
" Move between tabs
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
" current folder terminal launch
map <F7> :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>cd $VIM_DIR<CR>
