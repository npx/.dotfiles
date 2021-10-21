filetype plugin on
" highlight syntax
syntax on
" exrc: option to load vimrc files from project folder
set exrc
" keep the blocky cursor
set guicursor=
" show line numbers
set number
set relativenumber
" disable the swapfile
set noswapfile
" highlight all results
set hlsearch
" ignore case in search
set ignorecase
" show search results as you type
set incsearch
" keep visited buffers open
set hidden
" mute vim
set noerrorbells
" disable word wrap
set nowrap
" tab behavior
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
" no backup/autosave files
set noswapfile
set nobackup
" when scrolling keep distance to edge of screen
set scrolloff=8
" rulers
set colorcolumn=100
" keep a side column for addons
set signcolumn=yes
" more space for displaying messages
set cmdheight=2
" short update time (default is 4000ms)
set updatetime=50
" dont pass messages to |ins-completion-menu|
set shortmess+=c
" enable system clipboard
set clipboard+=unnamedplus
" open new split panes to right and below
set splitright
set splitbelow
" Plugins
call plug#begin('~/.vim/plugged')
    " Treesitter
    Plug 'nvim-treesitter/nvim-treesitter'

    " Color Theme
    Plug 'gruvbox-community/gruvbox'

    " Fuzzy finder
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Automatically set tabwitch
    Plug 'tpope/vim-sleuth'

    " LSP
    Plug 'neovim/nvim-lspconfig'
    
    " Autocomplete
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/nvim-cmp'
    
    " For vsnip user.
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'   

    " Misc
    Plug 'junegunn/goyo.vim'
    Plug 'preservim/nerdcommenter'
call plug#end()
" load lua modules
lua require("npx")
" set theme
colorscheme gruvbox
" use ' as leader
let mapleader = " "
" type 'ctrl+c' instead of ESC
inoremap <C-c> <Esc>
inoremap <Esc> <Nop>
" use ctrl+hjkl to move between split/vsplit panels
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" move selected block up and down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" some nice behavior
nnoremap Y yg$
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
" greatest remap ever
xnoremap <leader>p "_dP
" next greatest remap ever : asbjornHaland
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG
" deleting to black hole register
nnoremap <leader>d "_d
vnoremap <leader>d "_d