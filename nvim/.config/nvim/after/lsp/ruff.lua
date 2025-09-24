-- ruff: Python linter and formatter
local utils = require("npx.lsp.utils")

return {
  cmd = { utils.find_python_tool("ruff"), "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
}
