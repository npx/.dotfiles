if vim.g.current_compiler then
  return
end

vim.g.current_compiler = "angular"

vim.o.makeprg = "npx ng build"

vim.cmd [[
  setlocal errorformat=%EError:\ %f:%l:%c\ -\ %m,%-G%.%#
]]
