-- vtsls: the general TypeScript/JavaScript engine for .ts/.tsx/.js/.jsx.
--
-- Angular awareness on .ts (NG8113 unused-import, inline templates, and rename
-- that reaches the external .html) is provided by the standalone angularls,
-- which now also attaches to .ts (see lua/npx/lsp/init.lua). vtsls therefore no
-- longer injects the Angular tsserver plugin. To avoid two rename providers on
-- one .ts buffer, rename is handed to angularls in Angular projects (only it can
-- propagate a member rename into the component's external template).
--
-- TypeScript itself is always the PROJECT's copy (autoUseWorkspaceTsdk) — no
-- global TypeScript is used.

return {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
  },
  on_attach = function(client, bufnr)
    -- conform.nvim owns formatting
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- In Angular projects, let angularls own rename so a component-member rename
    -- also rewrites the external .html template (vtsls cannot see templates).
    if vim.fs.root(bufnr, { "angular.json", "nx.json" }) then
      client.server_capabilities.renameProvider = false
    end
  end,
}
