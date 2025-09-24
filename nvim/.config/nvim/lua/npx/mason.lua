-- Mason: installs LSP server binaries; mason-lspconfig auto-enables them.
require("mason").setup()

require("mason-lspconfig").setup({
  -- Auto-install the servers we use (lspconfig names).
  -- ty is handled separately (enabled explicitly in npx.lsp).
  ensure_installed = { "vtsls", "angularls", "lua_ls", "ruff", "eslint" },

  -- Auto-enable installed servers via vim.lsp.enable(), EXCEPT the cut ones
  -- (their binaries may still be installed until uninstalled from :Mason).
  automatic_enable = {
    exclude = { "ts_ls", "pylsp", "omnisharp", "shopify_theme_ls" },
  },
})
