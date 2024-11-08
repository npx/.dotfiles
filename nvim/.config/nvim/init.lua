-- Set leader before other plugins
vim.g.mapleader = ' '

-- Load lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Telescope
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",

  -- Color Theme
  "sainnhe/everforest",

  -- Automatically set tabwidth
  "tpope/vim-sleuth",

  -- LSP
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  -- Autocomplete
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/nvim-cmp",

  -- For vsnip user.
  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",

  -- Git
  "tpope/vim-fugitive",
  "junegunn/gv.vim",
  "sindrets/diffview.nvim",

  -- Formatting
  "sbdchd/neoformat",

  -- ChatGPT
  "robitx/gp.nvim",

  -- Misc
  "junegunn/goyo.vim",
  "kylechui/nvim-surround",
  "numToStr/Comment.nvim",
  "tamton-aquib/duck.nvim",
  "nvim-lualine/lualine.nvim",
  "numToStr/FTerm.nvim",
  "windwp/nvim-autopairs",
  "shortcuts/no-neck-pain.nvim",
  "stevearc/oil.nvim",

  -- Which Key
  "folke/which-key.nvim",

  -- Angular
  "softoika/ngswitcher.vim",

  -- TypeScript
  "nvim-lua/plenary.nvim",
  "jose-elias-alvarez/nvim-lsp-ts-utils",

  -- Lit
  "jonsmithers/vim-html-template-literals",

  -- HTML
  "alvan/vim-closetag",
})

-- enable termguicolors
vim.opt.termguicolors = true

-- load lua modules
require("npx")

-- set theme
-- Available values: 'hard', 'medium'(default), 'soft'
vim.g.everforest_background = 'medium'
vim.g.everforest_better_performance = 1
vim.g.everforest_enable_italic = 1
vim.g.everforest_transparent_background = 0
vim.g.everforest_dim_inactive_windows = 0
vim.g.everforest_sign_column_background = 'none' -- 'none', 'grey'
vim.g.everforest_ui_contrast = 'low' -- 'low', 'high'
vim.g.everforest_disable_terminal_colors = 1
vim.opt.background = 'dark'
vim.cmd('colorscheme everforest')

-- use ctrl+hjkl to move between split/vsplit panels
vim.keymap.set('n', '<Left>', '<C-w>h')
vim.keymap.set('n', '<Down>', '<C-w>j')
vim.keymap.set('n', '<Up>', '<C-w>k')
vim.keymap.set('n', '<Right>', '<C-w>l')

-- move selected block up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- some nice behavior
vim.keymap.set('n', 'Y', 'yg$')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'J', 'mzJ`z')

-- greatest remap ever
vim.keymap.set('x', '<leader>p', '"_dP')

-- next greatest remap ever : asbjornHaland
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', 'gg"+yG')

-- deleting to black hole register
vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>d', '"_d')

-- Try node_module formatters and autoformat on save
vim.g.neoformat_try_node_exe = 1
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("fmt", { clear = true }),
  pattern = "*",
  command = "undojoin | Neoformat",
})

-- configure template vim-html-template-literals
vim.g.htl_css_templates = 1

-- disable unused providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- keep clear console clean
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  command = "echon ''",
})

-- dont jump when selecting with *
vim.keymap.set('n', '*', ":let @/='\\<' . expand('<cword>') . '\\>' <bar> set hls <cr>", { silent = true })
