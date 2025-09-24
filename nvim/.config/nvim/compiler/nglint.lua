-- Angular lint compiler configuration
if vim.b.current_compiler then
    return
end

vim.b.current_compiler = "nglint"

vim.opt_local.makeprg = "npx ng lint"

-- Eslint --format stylish
vim.opt_local.errorformat = table.concat({
    "%-P%f,",
    "%\\s%#%l:%c %# %trror  %m,",
    "%\\s%#%l:%c %# %tarning  %m,",
    "%-Q,",
    "%-G%.%#,"
}, "")