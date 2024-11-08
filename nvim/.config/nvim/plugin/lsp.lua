vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.api.nvim_set_keymap('n', '<leader>vd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>vrr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>vrn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>vh', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>vca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>vsd', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>vf', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>vi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>vn', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>vp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>vsh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>cn', '<cmd>cnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cp', '<cmd>cprev<CR>', { noremap = true, silent = true })
