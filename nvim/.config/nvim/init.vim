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
set colorcolumn=80,100
" keep a side column for addons
set signcolumn=yes
" more space for displaying messages
set cmdheight=2
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
    Plug 'sainnhe/gruvbox-material'
    Plug 'catppuccin/nvim', {'as': 'catppuccin'}
    Plug 'marko-cerovac/material.nvim'
    Plug 'ray-x/aurora'

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

    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/gv.vim'

    " Formatting
    Plug 'sbdchd/neoformat'

    " Misc
    Plug 'junegunn/goyo.vim'
    Plug 'kylechui/nvim-surround'
    Plug 'numToStr/Comment.nvim'

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
" load lua modules
lua require("npx")
" setup comment plugin bindings 
lua require('Comment').setup()
" set theme
" let g:catppuccin_flavour = "mocha" " latte, frappe, macchiato, mocha
" colorscheme catppuccin
" set theme
" let g:gruvbox_material_background = 'hard'
" let g:gruvbox_material_transparent_background = 1
" let g:gruvbox_material_better_performance = 1
" colorscheme gruvbox-material
" set theme
" let g:material_style = "darker"
" colorscheme material
" set theme
set termguicolors
let g:aurora_italic = 1     " italic
let g:aurora_transparent = 1     " transparent
let g:aurora_bold = 1     " bold
colorscheme aurora
" use ' as leader
let mapleader = " "
nnoremap <Space> <Nop>
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
" inserting between brackets in new line
nnoremap <leader><Space> i<CR><Esc>O
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
