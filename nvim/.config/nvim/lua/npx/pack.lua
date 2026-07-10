-- Native plugin manager (vim.pack, Neovim 0.12+) — replaces lazy.nvim.
-- No lazy-loading: plugins load eagerly at startup, in list order.
-- The lockfile lives at ~/.config/nvim/nvim-pack-lock.json (repo-local, commit it).

-- Rebuild treesitter parsers when the plugin is installed/updated
-- (the only real build step; registered before add() that installs it).
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local d = ev.data or {}
    local name = d.spec and d.spec.name
    if name == "nvim-treesitter" and (d.kind == "install" or d.kind == "update") then
      vim.schedule(function()
        pcall(vim.cmd, "TSUpdate")
      end)
    end
  end,
})

local function gh(repo, version)
  return { src = "https://github.com/" .. repo, version = version }
end

-- Dependencies must be listed BEFORE their dependents (no auto-ordering).
vim.pack.add({
  -- Core library (telescope/diffview depend on it)
  gh("nvim-lua/plenary.nvim"),

  -- Colorscheme
  gh("sainnhe/everforest"),

  -- Treesitter (main branch — requires Neovim 0.12)
  gh("nvim-treesitter/nvim-treesitter", "main"),

  -- LSP: data provider + installer + bridge
  -- (mason and nvim-lspconfig before mason-lspconfig)
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason.nvim"),
  gh("mason-org/mason-lspconfig.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),

  -- Editing
  gh("kylechui/nvim-surround"),
  gh("windwp/nvim-autopairs"),
  gh("windwp/nvim-ts-autotag"),
  gh("tpope/vim-sleuth"),

  -- Formatting
  gh("stevearc/conform.nvim"),

  -- Fuzzy finder (plenary above)
  gh("nvim-telescope/telescope.nvim"),

  -- UI
  gh("nvim-lualine/lualine.nvim"),
  gh("stevearc/oil.nvim"),

  -- Git (diffview: maintained fork of the abandoned upstream)
  gh("tpope/vim-fugitive"),
  gh("dlyongemallo/diffview.nvim"),

  -- Markdown/HTML live preview
  gh("brianhuster/live-preview.nvim"),

  -- Claude Code IDE integration (external claude in a tmux pane)
  gh("coder/claudecode.nvim"),
})

-- Plugin configuration (deps already loaded above; order here is for readability).
require("npx.colorscheme")
require("npx.treesitter")
require("npx.surround")
require("nvim-autopairs").setup({})
require("nvim-ts-autotag").setup({})
require("npx.formatting")
require("npx.statusline")
require("oil").setup({})
require("npx.telescope")
require("npx.ngswitcher")
require("npx.mason")
require("npx.lsp")
require("npx.lsp-keys")
require("npx.completion")
require("npx.claudecode")
