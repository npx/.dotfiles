-- ty: Astral's Python type checker
local utils = require("npx.lsp.utils")

return {
  cmd = { utils.find_python_tool("ty"), "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ty.toml", ".git" },
}
