-- LSP configuration utilities
local M = {}

-- Find executable with fallback priority: project venv -> Mason -> system
-- @param tool_name string: name of the executable (e.g., "ruff", "ty", "mypy")
-- @return string: path to the executable
function M.find_python_tool(tool_name)
  local root_dir = vim.fs.root(0, { ".git", "pyproject.toml" })
  local venv_tool = root_dir and (root_dir .. "/.venv/bin/" .. tool_name) or nil
  local mason_tool = vim.fn.stdpath('data') .. '/mason/bin/' .. tool_name

  -- Prefer project's venv tool
  if venv_tool and vim.fn.executable(venv_tool) == 1 then
    return venv_tool
  -- Fallback to Mason's tool
  elseif vim.fn.executable(mason_tool) == 1 then
    return mason_tool
  -- Fallback to system tool
  else
    return tool_name
  end
end

return M
