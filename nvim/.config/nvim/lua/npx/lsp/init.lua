-- Common LSP setup.

-- Rounded borders for hover / signature / diagnostic floats
-- (replaces the deprecated vim.lsp.with(vim.lsp.handlers.hover, ...) handler).
vim.o.winborder = "rounded"

-- angularls attaches to BOTH .ts and templates (its nvim-lspconfig default).
-- On .ts it emits Angular diagnostics (e.g. NG8113 "unused standalone import")
-- and — crucially — owns rename, so renaming a component member also rewrites
-- the external .html template (a plain TS server cannot reach templates). On
-- .html it type-checks templates (@if/@for control-flow, unknown-block errors
-- like `@fi`) and resolves template -> component definitions. vtsls stays the
-- general TS engine with its rename disabled in Angular projects so rename
-- routes to angularls (see after/lsp/vtsls.lua). Its command + project-local
-- version resolution live in after/lsp/angularls.lua.
-- (vim.lsp.config REPLACES the nvim-lspconfig default filetypes list.)
vim.lsp.config("angularls", {
  filetypes = { "typescript", "html", "typescriptreact", "htmlangular" },
})

-- Most servers (vtsls, angularls, lua_ls, ruff, eslint) are auto-enabled by
-- mason-lspconfig (automatic_enable). `ty` (Astral type checker) is configured
-- entirely by after/lsp/ty.lua, so enable it explicitly here.
vim.lsp.enable("ty")

-- nvim-lspconfig no longer ships :LspInfo. Restore a lightweight equivalent
-- that lists the clients attached to the current buffer (native detail lives
-- in :checkhealth vim.lsp).
vim.api.nvim_create_user_command("LspInfo", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
    return
  end
  local lines = { "LSP clients attached to buffer:" }
  for _, c in ipairs(clients) do
    lines[#lines + 1] = ("  • %s  (root: %s)"):format(c.name, c.root_dir or "n/a")
  end
  lines[#lines + 1] = "(full detail: :checkhealth vim.lsp)"
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "List LSP clients attached to the current buffer" })
