-- nvim-treesitter (main branch, Neovim 0.12+):
-- install parsers programmatically + enable built-in highlighting per filetype.
-- (The old `require'nvim-treesitter.configs'.setup{highlight={enable=true}}`
--  API no longer exists on the main branch.)

local parsers = {
  "lua", "vim", "vimdoc", "query",
  "bash", "diff", "gitcommit",
  "markdown", "markdown_inline",
  "json", "yaml", "toml",
  "html", "css", "scss",
  "javascript", "typescript", "tsx", "angular",
  "python",
}

-- Install any missing parsers (async; no-op when already present).
pcall(function()
  require("nvim-treesitter").install(parsers)
end)

-- Angular component templates use filetype 'htmlangular'; map it to the
-- 'angular' treesitter parser.
pcall(vim.treesitter.language.register, "angular", "htmlangular")

-- Enable treesitter highlighting for any buffer whose filetype has a parser.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})
