-- Angular component file switching — native replacement for ngswitcher.vim
-- (dead upstream since 2020). Switches between foo.component.{ts,html,css/scss,spec.ts}.

local function component_base()
  local full = vim.fn.expand("%:p")
  if full:match("%.spec%.ts$") then
    return (full:gsub("%.spec%.ts$", ""))
  end
  -- strip the final extension (.ts/.html/.css/.scss)
  return (full:gsub("%.%w+$", ""))
end

local function open(target, vertical)
  local base = component_base()
  local file = base .. target
  local cmd = vertical and "vsplit " or "edit "
  vim.cmd(cmd .. vim.fn.fnameescape(file))
end

-- CSS: prefer an existing .scss, else .css
local function open_css(vertical)
  local base = component_base()
  local target = ".css"
  if vim.fn.filereadable(base .. ".scss") == 1 then
    target = ".scss"
  end
  open(target, vertical)
end

local defs = {
  TS = ".ts",
  HTML = ".html",
  Spec = ".spec.ts",
}
for name, ext in pairs(defs) do
  vim.api.nvim_create_user_command("NgSwitch" .. name, function()
    open(ext, false)
  end, {})
  vim.api.nvim_create_user_command("VNgSwitch" .. name, function()
    open(ext, true)
  end, {})
end
vim.api.nvim_create_user_command("NgSwitchCSS", function()
  open_css(false)
end, {})
vim.api.nvim_create_user_command("VNgSwitchCSS", function()
  open_css(true)
end, {})

-- Keymaps (unchanged from the old plugin)
vim.keymap.set("n", "<Leader>nj", "<cmd>NgSwitchTS<CR>")
vim.keymap.set("n", "<Leader>nk", "<cmd>NgSwitchHTML<CR>")
vim.keymap.set("n", "<Leader>nl", "<cmd>NgSwitchCSS<CR>")
vim.keymap.set("n", "<Leader>n;", "<cmd>NgSwitchSpec<CR>")

vim.keymap.set("n", "<Leader>nJ", "<cmd>VNgSwitchTS<CR>")
vim.keymap.set("n", "<Leader>nK", "<cmd>VNgSwitchHTML<CR>")
vim.keymap.set("n", "<Leader>nL", "<cmd>VNgSwitchCSS<CR>")
vim.keymap.set("n", "<Leader>n:", "<cmd>VNgSwitchSpec<CR>")
