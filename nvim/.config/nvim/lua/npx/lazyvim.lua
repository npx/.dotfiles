return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Color Theme
  {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_better_performance = 1
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_transparent_background = 0
      vim.g.everforest_dim_inactive_windows = 0
      vim.g.everforest_sign_column_background = "none"
      vim.g.everforest_ui_contrast = "low"
      vim.g.everforest_disable_terminal_colors = 1
      vim.cmd("set bg=dark")
      vim.cmd("colorscheme everforest")
    end,
  },

  -- Automatically set tabwidth
  {
    "tpope/vim-sleuth",
  },

  -- LSP
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
  },

  -- Git
  {
    "tpope/vim-fugitive",
  },
  {
    "junegunn/gv.vim",
  },
  {
    "sindrets/diffview.nvim",
  },

  -- Formatting
  {
    "sbdchd/neoformat",
  },

  -- ChatGPT
  {
    "robitx/gp.nvim",
  },

  -- Misc
  {
    "junegunn/goyo.vim",
  },
  {
    "kylechui/nvim-surround",
  },
  {
    "numToStr/Comment.nvim",
  },
  {
    "tamton-aquib/duck.nvim",
  },
  {
    "nvim-lualine/lualine.nvim",
  },
  {
    "numToStr/FTerm.nvim",
  },
  {
    "windwp/nvim-autopairs",
  },
  {
    "shortcuts/no-neck-pain.nvim",
  },
  {
    "stevearc/oil.nvim",
  },

  -- Which Key
  {
    "folke/which-key.nvim",
  },

  -- Angular
  {
    "softoika/ngswitcher.vim",
  },

  -- TypeScript
  {
    "jose-elias-alvarez/nvim-lsp-ts-utils",
  },

  -- Lit
  {
    "jonsmithers/vim-html-template-literals",
  },

  -- HTML
  {
    "alvan/vim-closetag",
  },

  -- Add configuration for `cmp` plugin
  require("npx.auto-complete"),

  -- Add configuration for `buffer-management`
  require("npx.buffer-management"),

  -- Add configuration for `gp` plugin
  require("npx.chatgpt"),

  -- Add configuration for `Comment` plugin
  require("npx.comment"),

  -- Add configuration for `FTerm` plugin
  require("npx.fterm"),

  -- Add configuration for `lsp` plugin
  require("npx.lsp"),

  -- Add configuration for `lualine` plugin
  require("npx.statusline"),

  -- Add configuration for `nvim-surround` plugin
  require("npx.surround"),

  -- Add configuration for `telescope` plugin
  require("npx.telescope"),

  -- Add configuration for `nvim-treesitter` plugin
  require("npx.treesitter"),

  -- Add configuration for `which-key` plugin
  require("npx.which-key"),
}
