-- LSP keybindings
vim.keymap.set('n', '<leader>vd', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>vh', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>vsd', function()
    vim.diagnostic.open_float(nil, { scope = "line" })
end)

vim.keymap.set('n', '<leader>vf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>vi', vim.lsp.buf.implementation)
vim.keymap.set('n', '<leader>vn', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>vp', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>vsh', vim.lsp.buf.signature_help)

-- TypeScript import keybindings (for typescript-tools.nvim)
-- These only work in TypeScript/JavaScript buffers
vim.keymap.set('n', '<leader>gs', function()
    vim.lsp.buf.code_action({
        apply = true,
        context = {
            only = { "source.organizeImports" },
            diagnostics = {},
        },
    })
end, { desc = 'Organize imports' })

vim.keymap.set('n', '<leader>gi', function()
    vim.lsp.buf.code_action({
        apply = true,
        context = {
            only = { "source.addMissingImports" },
            diagnostics = {},
        },
    })
end, { desc = 'Add missing imports' })
