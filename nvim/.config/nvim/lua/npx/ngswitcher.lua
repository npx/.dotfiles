vim.api.nvim_set_keymap('n', '<Leader>nj', ':NgSwitchTS<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>nk', ':NgSwitchHTML<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>nl', ':NgSwitchCSS<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>n;', ':NgSwitchSpec<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader>nJ', ':VNgSwitchTS<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>nK', ':VNgSwitchHTML<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>nL', ':VNgSwitchCSS<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>n:', ':VNgSwitchSpec<CR>', { noremap = true, silent = true })
