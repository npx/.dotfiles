require("npx.buffer-management")

-- Setup NetRW
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Ctrl-f: tmux-sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- show virtual_text
vim.diagnostic.config({ virtual_text = true })

-- buffer to tab / tab close
vim.keymap.set("n", "<leader>tt", "<cmd>silent tabnew %<CR>")
vim.keymap.set("n", "<leader>tb", "<cmd>silent tabclose<CR>")

-- splits
vim.keymap.set("n", "<leader>sv", "<cmd>silent vsplit<CR>")
vim.keymap.set("n", "<leader>sh", "<cmd>silent split<CR>")

-- close
vim.keymap.set("n", "<leader>q", "<cmd>silent q<CR>")
vim.keymap.set("n", "<leader>Q", "<cmd>silent q!<CR>")
