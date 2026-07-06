# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository managed with GNU Stow for symlinking configuration files. It contains configurations for:
- **nvim**: Neovim editor with Lua configuration
- **term**: Terminal environment (bash, alacritty, tmux)
- **wm**: Window manager (AeroSpace configuration)
- **git**: Git configuration
- **lazygit**: Lazygit configuration

## Key Commands

### Stow Management
```bash
# Install all terminal configs to home directory
stow -t $HOME term

# Install specific config module
stow -t $HOME nvim
stow -t $HOME wm
```

### Development Environment
The bash profile defines several important environment variables and functions:
- `$WORK`: Work directory (`$HOME/Work`)
- `$PROJECTS`: Personal projects (`$HOME/Private/github.com/npx`)
- `$DOTFILES`: This dotfiles repo (`$PROJECTS/.dotfiles`)

### Navigation Aliases
- `ww`: cd to work directory
- `pp`: cd to projects directory  
- `df`: cd to dotfiles directory
- `d`: Interactive directory switching with fzf from dirs stack

### Tmux Session Management
The repository includes `tmux-sessionizer` script (bound to Ctrl+F) that:
- Lists directories from `$WORK`, `$WORK/Materials`, and `$PROJECTS`
- Creates or switches to tmux sessions named after selected directories
- Usage: `tmux-sessionizer [optional-path]`

## Architecture

### Neovim Configuration
- **Main config**: `nvim/.config/nvim/init.lua` (pure Lua; entry point that wires everything together)
- **Lua modules**: Located in `nvim/.config/nvim/lua/npx/`
- **Plugin manager**: Native `vim.pack` (Neovim 0.12+) — no lazy.nvim/vim-plug. Specs in `lua/npx/pack.lua`, lockfile `nvim-pack-lock.json` (committed). Plugins load eagerly in list order; deps must precede dependents.
- **Plugins**: Telescope, nvim-treesitter (main branch), nvim-lspconfig + mason/mason-lspconfig, conform.nvim, lualine, oil.nvim, vim-fugitive + diffview.nvim, nvim-surround, nvim-autopairs, nvim-ts-autotag, vim-sleuth, live-preview.nvim
- **Theme**: Everforest colorscheme
- **LSP**: Mason for server install; per-server config in `after/lsp/*.lua` (vtsls, angularls, eslint, lua_ls, ruff, ty); shared setup in `lua/npx/lsp/`, keymaps in `lua/npx/lsp-keys.lua`
- **Formatting**: conform.nvim, format-on-save (prettierd/prettier, shfmt); manual `<leader>fm`. Config in `lua/npx/formatting.lua`
- **Leader key**: Space

Key Neovim features:
- Angular support: `.component.html` detected as `htmlangular`, angularls attaches to templates, native `ngswitcher.lua` (ts↔html↔css↔spec switching), `:compiler angular`/`nglint`
- Custom keybindings for window navigation with arrow keys (`<Left>/<Down>/<Up>/<Right>` → split moves)
- Oil.nvim as file explorer (`<leader>o`), multicursor support

### Terminal Environment  
- **Shell**: Bash with custom profile in `term/.bash_profile`
- **Terminal**: Alacritty with transparency and FiraCode Nerd Font
- **Font size control**: `fs [size]` function to dynamically change Alacritty font size
- **NVM integration**: Lazy-loaded to improve shell startup time

### Window Management
- **WM**: AeroSpace (tiling window manager for macOS)
- **Config**: `wm/.aerospace.toml` with custom keybindings
- **Key prefix**: Ctrl+Shift+Alt for all WM operations
- **Workspaces**: 7 predefined workspaces with specific app assignments
- **Integration**: Sketchybar for status bar

### Workspace Layout
1. `1-default`: General workspace
2. `2-company`: Work apps (Slack automatically assigned)  
3. `3-communication`: Teams, Zoom, etc.
4. `4-term`: Terminal applications (Alacritty auto-assigned)
5. `5-build`: Development/build workspace
6. `6-vm`: Virtual machines
7. `7-private`: Personal apps (Discord auto-assigned)

## Package Management

### Homebrew Dependencies
- **Formulas** (in `brew` file): Core tools like neovim, fzf, tmux, direnv, stow
- **Casks** (in `brew.casks` file): GUI applications like Alacritty, AeroSpace, fonts

### Node.js Management
- Uses NVM with lazy loading to improve shell performance
- Automatically activates NVM when entering directories with package.json
- Custom wrapper functions for node, npm, npx commands

## Special Features

### Presentation Mode
- `git-demo [name]`: Sets up git demo environment with custom prompt
- `webinar [name]`: Sets up webinar environment
- `git-watch`: Live updating git log display
- `git-status`: Live updating git status display

### Chrome Workspace Integration  
Functions to open Chrome in specific workspaces:
- `chrome_work`: Opens in company workspace
- `chrome_dev`: Opens in build workspace  
- `chrome_private`: Opens in private workspace

### Development Utilities
- `ducks`: Show largest files/directories
- `slides`: Start Marp presentation server for slides
- Rust and dotnet tool path integration
- `thefuck` command correction tool integration