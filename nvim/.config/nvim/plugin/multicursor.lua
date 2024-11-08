-- multicursor moves
-- Replace selected characters, saving the word to which they belong
vim.api.nvim_set_keymap('x', '<leader>ss', '"sy:let @w=\'\\<\'.vim.fn.expand(\'<cword>\').\'\\>\' <bar> let @/=@s<CR>cgn', { noremap = true, silent = true })

-- Search and replace previously replaced characters
-- -> Use the dot ('.') command

-- Search and replace the characters if they appear within the same word
-- (not working?)
vim.api.nvim_set_keymap('n', '<C-s>', '/<C-r>w<CR><left>/<C-r>s<CR>.', { noremap = true, silent = true })

-- Search for the next occurrence of the saved word (skip replace)
vim.api.nvim_set_keymap('n', '<C-n>', '/<C-r>w<CR>', { noremap = true, silent = true })

-- Replace full word
vim.api.nvim_set_keymap('n', '<leader>sr', ':let @/=\'\\<\'.vim.fn.expand(\'<cword>\').\'\\>\'<CR>cgn', { noremap = true, silent = true })

-- Append to the end of a word
vim.api.nvim_set_keymap('n', '<leader>sa', ':let @/=\'\\<\'.vim.fn.expand(\'<cword>\').\'\\>\'<CR>cgn<C-r>"', { noremap = true, silent = true })

-- Macro Replay on matches
vim.g.mc = "y/\\V\\<C-r>=vim.fn.escape(@\", '/')\\<CR>\\<CR>"

local function SetupCR()
  vim.api.nvim_set_keymap('n', '<Enter>', ':nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=vim.fn.strpart(@z,0,vim.fn.strlen(@z)-1)<CR>n@z', { noremap = true, silent = true })
end

vim.api.nvim_set_keymap('n', '<leader>sm', ':lua SetupCR()<CR>*``qz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'cq', '":\\<C-u>lua SetupCR()<CR>" .. "gv" .. vim.g.mc .. "``qz"', { noremap = true, expr = true })
