local setqflist = vim.fn.setqflist
local getqflist = vim.fn.getqflist

vim.api.nvim_buf_set_keymap(0, 'n', 'dd', [[<Cmd>lua setqflist(vim.tbl_filter(function(idx) return idx ~= vim.fn.line('.') - 1 end, getqflist()), 'r')<CR>]], { noremap = true, silent = true })
