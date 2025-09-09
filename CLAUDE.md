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
- **Main config**: `nvim/.config/nvim/init.vim` (VimScript with Lua modules)
- **Lua modules**: Located in `nvim/.config/nvim/lua/npx/`
- **Plugins**: Uses vim-plug with plugins like Telescope, Treesitter, LSP, etc.
- **Theme**: Everforest colorscheme
- **LSP**: Configured with Mason for language server management
- **Leader key**: Space

Key Neovim features:
- Lazy loading for NVM when editing JS/TS projects
- Auto-formatting with Neoformat on save
- ChatGPT and Claude plugins integrated
- Custom keybindings for window navigation with arrow keys

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