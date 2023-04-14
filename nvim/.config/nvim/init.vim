filetype plugin on
" highlight syntax
syntax on
" exrc: option to load vimrc files from project folder
set exrc
" keep the blocky cursor
" set guicursor=
" show line numbers
set number
set relativenumber
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
set sidescrolloff=8
" rulers
set colorcolumn=100
" keep a side column for addons
set signcolumn=no
" more space for displaying messages
set cmdheight=1
" dont show mode in cmdline
set noshowmode
" short update time (default is 4000ms)
set updatetime=50
" dont pass messages to |ins-completion-menu|
set shortmess+=c
" enable system clipboard
" set clipboard+=unnamedplus
" open new split panes to right and below
set splitright
set splitbelow
" Plugins
call plug#begin('~/.vim/plugged')
    " Treesitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " Telescope
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    " Harpoon
    Plug 'ThePrimeagen/harpoon'

    " Color Theme
    Plug 'ray-x/aurora'

    " Automatically set tabwidth
    Plug 'tpope/vim-sleuth'

    " LSP
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'neovim/nvim-lspconfig'
    
    " Autocomplete
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/nvim-cmp'
    
    " For vsnip user.
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'   

    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/gv.vim'

    " Formatting
    Plug 'sbdchd/neoformat'

    " Misc
    Plug 'junegunn/goyo.vim'
    Plug 'kylechui/nvim-surround'
    Plug 'numToStr/Comment.nvim'
    Plug 'tamton-aquib/duck.nvim'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'numToStr/FTerm.nvim'
    Plug 'windwp/nvim-autopairs'
    Plug 'shortcuts/no-neck-pain.nvim'
    Plug 'stevearc/oil.nvim'
    Plug 'chrisgrieser/nvim-early-retirement'

    " Which Key
    Plug 'folke/which-key.nvim'

    " Angular
    Plug 'softoika/ngswitcher.vim'
    
    " TypeScript
    Plug 'nvim-lua/plenary.nvim'
    Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

    " Lit
    Plug 'jonsmithers/vim-html-template-literals'

    " HTML
    Plug 'alvan/vim-closetag'
call plug#end()
" enable termguicolors
set termguicolors

" load lua modules
lua require("npx")

" set theme
let g:aurora_italic = 1          " italic
let g:aurora_transparent = 1     " transparent
let g:aurora_bold = 1            " bold
colorscheme aurora

" use ' as leader
let mapleader = " "
nnoremap <Space> <Nop>
" use ctrl+hjkl to move between split/vsplit panels
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
" Try node_module formatters and autoformat on save
let g:neoformat_try_node_exe = 1
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
" configure template vim-html-template-literals
let g:htl_css_templates = 1
" disable unused providers
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python3_provider = 0
" keep clear console clean 
autocmd CursorHold * echon ''
