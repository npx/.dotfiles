-- angularls: Angular Language Server (ngserver).
--
-- Filetypes are set in lua/npx/lsp/init.lua so it attaches to BOTH .ts and
-- templates. Everything it analyzes with is resolved from the PROJECT's
-- node_modules — no global Angular install is required:
--   * the ngserver HOST prefers <root>/node_modules/.bin/ngserver,
--   * TypeScript and @angular/language-service (which does the actual template
--     type-checking) are probed project-first,
-- falling back to Mason's self-contained copy only when the project lacks them.
-- --angularCoreVersion tells a newer language-service which Angular version the
-- project targets (it adapts its feature set down; it cannot adapt up, so the
-- server major must be >= the project's Angular major).

local uv = vim.uv or vim.loop

-- Prefer the project's own ngserver binary; else Mason's; else PATH.
local function ngserver_bin(root)
  if root then
    local local_bin = root .. "/node_modules/.bin/ngserver"
    if uv.fs_stat(local_bin) then
      return local_bin
    end
  end
  local mason = vim.fn.exepath("ngserver")
  return mason ~= "" and mason or "ngserver"
end

local function angular_core_version(root)
  local pkg = root and (root .. "/package.json")
  if not pkg or not uv.fs_stat(pkg) then
    return ""
  end
  local ok, blob = pcall(vim.fn.readblob, pkg)
  if not ok or not blob then
    return ""
  end
  local json = vim.json.decode(blob) or {}
  local v = (json.dependencies or {})["@angular/core"]
    or (json.devDependencies or {})["@angular/core"]
    or ""
  return v:match("%d+%.%d+%.%d+") or ""
end

return {
  cmd = function(dispatchers, config)
    local root = (config and config.root_dir) or vim.fn.getcwd()
    local proj = root .. "/node_modules"
    -- Mason package dir, used only as a fallback probe location.
    local mason_nm = vim.fn.stdpath("data")
      .. "/mason/packages/angular-language-server/node_modules"

    -- TypeScript: project first, Mason last.
    local ts_probe = table.concat({ proj, mason_nm }, ",")
    -- @angular/language-service: project first (both the nested-in-language-server
    -- layout and a bare project install are found via require.resolve walk-up),
    -- Mason last.
    local ng_probe = table.concat({
      proj .. "/@angular/language-server/node_modules",
      proj,
      mason_nm .. "/@angular/language-server/node_modules",
    }, ",")

    local cmd = {
      ngserver_bin(root),
      "--stdio",
      "--tsProbeLocations", ts_probe,
      "--ngProbeLocations", ng_probe,
      "--angularCoreVersion", angular_core_version(root),
    }
    return vim.lsp.rpc.start(cmd, dispatchers)
  end,

  on_attach = function(_client)
    -- Angular error format for :make (see compiler/angular.lua)
    vim.cmd [[compiler angular]]
  end,
}
