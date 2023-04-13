require("npx.auto-complete")
require("npx.comment")
require("npx.lsp")
require("npx.statusline")
require("npx.surround")
require("npx.telescope")
require("npx.treesitter")

-- Setup NetRW
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Ctrl-f: tmux-sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- show virtual_text
vim.diagnostic.config({
	virtual_text = true,
})
