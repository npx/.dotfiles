-- Quickfix buffer specific keybinding
-- Delete entries from quickfix list with dd
vim.keymap.set('n', 'dd', function()
    -- Mark position
    vim.cmd('mark j')
    -- Remove current quickfix entry
    local qflist = vim.fn.getqflist()
    local line_nr = vim.fn.line('.') - 1
    table.remove(qflist, line_nr + 1)
    vim.fn.setqflist(qflist, 'r')
    -- Restore position
    vim.cmd("normal! 'j")
end, { buffer = true, silent = true })