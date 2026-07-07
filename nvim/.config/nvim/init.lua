-- Enable filetype plugin
vim.cmd('filetype plugin on')

-- Highlight syntax
vim.cmd('syntax on')

-- Angular component templates: detect as 'htmlangular' (Neovim doesn't by
-- default). Enables the Angular treesitter parser + prettier and lets angularls
-- (scoped to html/htmlangular) engage on component templates.
vim.filetype.add({
  pattern = { ['.*%.component%.html'] = 'htmlangular' },
})

-- Exrc: option to load vimrc files from project folder
vim.opt.exrc = true

-- Keep the blocky cursor
-- vim.opt.guicursor = ""

-- Highlight line the cursor is in
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'screenline'

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Highlight all results
vim.opt.hlsearch = true

-- Ignore case in search
vim.opt.ignorecase = true

-- Show search results as you type
vim.opt.incsearch = true

-- Keep visited buffers open
vim.opt.hidden = true

-- Mute vim
vim.opt.errorbells = false

-- Disable word wrap
vim.opt.wrap = false

-- Tab behavior
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- No backup/autosave files
vim.opt.swapfile = false
vim.opt.backup = false

-- When scrolling keep distance to edge of screen
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 999

-- Rulers
vim.opt.colorcolumn = "100,140"

-- Keep a side column for addons
vim.opt.signcolumn = "no"

-- More space for displaying messages
vim.opt.cmdheight = 1

-- Don't show mode in cmdline
vim.opt.showmode = false

-- Short update time (default is 4000ms)
vim.opt.updatetime = 50

-- Don't pass messages to |ins-completion-menu|
vim.opt.shortmess:append("c")

-- Enable system clipboard
-- vim.opt.clipboard:append("unnamedplus")

-- Open new split panes to right and below
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Use <Space> as leader
vim.g.mapleader = " "
vim.keymap.set('n', '<Space>', '<Nop>')

-- Enable termguicolors
vim.opt.termguicolors = true

-- Use ctrl+hjkl to move between split/vsplit panels
vim.keymap.set('n', '<Left>', '<C-w>h')
vim.keymap.set('n', '<Down>', '<C-w>j')
vim.keymap.set('n', '<Up>', '<C-w>k')
vim.keymap.set('n', '<Right>', '<C-w>l')

-- Move selected block up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Some nice behavior
vim.keymap.set('n', 'Y', 'yg$')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'J', 'mzJ`z')

-- Greatest remap ever
vim.keymap.set('x', '<leader>p', '"_dP')

-- Next greatest remap ever : asbjornHaland
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', 'gg"+yG')

-- Deleting to black hole register
vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>d', '"_d')

-- Disable unused providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Keep clear console clean
vim.api.nvim_create_autocmd('CursorHold', {
    pattern = '*',
    callback = function() vim.cmd('echon ""') end
})

-- Don't jump when selecting with *
vim.keymap.set('n', '*', function()
    vim.fn.setreg('/', '\\<' .. vim.fn.expand('<cword>') .. '\\>')
    vim.opt.hlsearch = true
end, { silent = true })

-- Quickfix navigation
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.keymap.set('n', '<leader>cn', '<cmd>cnext<CR>')
vim.keymap.set('n', '<leader>cp', '<cmd>cprev<CR>')

-- Load multicursor functionality
require("npx.multicursor")

-- Oil keybindings (Oil is loaded immediately via lazy.nvim)
vim.keymap.set("n", "<leader>o", "<cmd>Oil<CR>")
vim.keymap.set("n", "<leader>O", "<cmd>vsplit | Oil<CR>")

-- Bootstrap plugins with the native package manager (vim.pack, Neovim 0.12+)
require("npx.pack")

-- Load lua modules
require("npx")
