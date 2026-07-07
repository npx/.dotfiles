-- Angular compiler configuration
if vim.b.current_compiler then
    return
end

vim.b.current_compiler = "angular"

vim.opt_local.makeprg = "npx ng build"
vim.opt_local.errorformat = "%EError: %f:%l:%c - %m,%-G%.%#"