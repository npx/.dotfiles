-- ESLint: JavaScript/TypeScript linter
return {
  filetypes = {
    'javascript', 'javascriptreact', 'javascript.jsx', 'typescript',
    'typescriptreact', 'typescript.tsx', 'vue', 'svelte', 'astro', 'html'
  },
  on_attach = function(client)
    -- Check if this is an Angular project
    local root_dir = vim.fn.getcwd()
    local angular_config = vim.fn.glob(root_dir .. "/angular.json")
    if angular_config ~= "" then
      -- Disable references in ESLint for Angular projects to avoid duplicates
      client.server_capabilities.referencesProvider = false
    end
  end,
  on_new_config = function(config, new_root_dir)
    -- The "workspaceFolder" is a VSCode concept. It limits how far the
    -- server will traverse the file system when locating the ESLint config
    -- file (e.g., .eslintrc).
    config.settings.workspaceFolder = {
      uri = vim.loop.cwd(),
      name = vim.fn.fnamemodify(new_root_dir, ":t")
    }
  end
}
