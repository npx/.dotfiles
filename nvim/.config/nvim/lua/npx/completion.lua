-- Native LSP completion (replaces the nvim-cmp + vsnip stack).
-- Enable autotriggered LSP completion per client; vim.snippet (built-in)
-- expands server-returned snippet bodies. No plugins.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

-- Native autotrigger only fires on the server's trigger characters (e.g. '.').
-- Map <C-Space> to pop the completion menu on demand while typing an identifier.
vim.keymap.set("i", "<C-Space>", function()
  vim.lsp.completion.get()
end, { desc = "Trigger LSP completion" })

-- Insert-mode popup navigation (ported from the old cmp mappings).
local ok_pairs, npairs = pcall(require, "nvim-autopairs")

vim.keymap.set("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })

vim.keymap.set("i", "<Down>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Down>"
end, { expr = true })

vim.keymap.set("i", "<Up>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<Up>"
end, { expr = true })

-- <CR>: confirm the selected completion item, otherwise a normal CR
-- (delegated to nvim-autopairs so bracket/newline expansion still works).
vim.keymap.set("i", "<CR>", function()
  if vim.fn.complete_info({ "selected" }).selected ~= -1 then
    return vim.keycode("<C-y>")
  end
  if ok_pairs then
    return npairs.autopairs_cr()
  end
  return vim.keycode("<CR>")
end, { expr = true, replace_keycodes = false })
