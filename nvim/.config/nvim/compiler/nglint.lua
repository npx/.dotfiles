if vim.g.current_compiler then
  return
end

vim.g.current_compiler = "nglint"

vim.o.makeprg = "npx ng lint"

vim.cmd([[
  setlocal errorformat^=%-P%f,
        \%\\s%#%l:%c\ %#\ %trror\ \ %m,
        \%\\s%#%l:%c\ %#\ %tarning\ \ %m,
        \%-Q,
        \%-G%.%#,
]])
