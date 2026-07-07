-- Multicursor functionality
-- Replace selected characters, saving the word to which they belong
vim.keymap.set('x', '<leader>ss', '"sy:let @w=\'\\<\'.expand(\'<cword>\').\'\\>\' <bar> let @/=@s<CR>cgn')

-- Search and replace the characters if they appear within the same word
vim.keymap.set('n', '<C-s>', '/<C-r>w<CR><left>/<C-r>s<CR>.')

-- Search for the next occurrence of the saved word (skip replace)
vim.keymap.set('n', '<C-n>', '/<C-r>w<CR>')

-- Replace full word
vim.keymap.set('n', '<leader>sr', ':let @/=\'\\<\'.expand(\'<cword>\').\'\\>\'<CR>cgn')

-- Append to the end of a word
vim.keymap.set('n', '<leader>sa', ':let @/=\'\\<\'.expand(\'<cword>\').\'\\>\'<CR>cgn<C-r>"')

-- Macro Replay on matches
vim.g.mc = [[y/\V<C-r>=escape(@", '/')<CR><CR>]]

-- Function to setup CR for macro replay
vim.cmd([[
function! SetupCR()
  nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
endfunction
]])

vim.keymap.set('n', '<leader>sm', '<cmd>call SetupCR()<CR>*``qz')
vim.keymap.set('v', 'cq', function()
    vim.cmd('call SetupCR()')
    return 'gv' .. vim.g.mc .. '``qz'
end, { expr = true })