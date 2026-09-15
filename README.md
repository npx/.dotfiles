# My .dotfiles

macOS setup managed by a nix flake (nix-darwin + home-manager). Config files
stay plain files in this repo; `modules/home/lib/stow.nix` links them into
`$HOME` as out-of-store symlinks, so editing a dotfile never needs a rebuild.

| Package | Contents |
| ------- | -------- |
| `term/` | bash, zsh, alacritty, tmux, scripts (`tmux-sessionizer`) |
| `nvim/` | Neovim (pure Lua, native `vim.pack`) |
| `wm/`   | AeroSpace + sketchybar |
| `git/`  | git aliases and config |

## Fresh machine

1. **Command line tools** (provides `git` for the clone):

   ```sh
   xcode-select --install
   ```

2. **Nix** — official upstream installer:

   ```sh
   sh <(curl -L https://nixos.org/nix/install)
   ```

3. **Clone** — the path is load-bearing (symlinks point into it; anywhere
   else and they dangle). HTTPS needs no auth; add an SSH key later for
   pushing.

   ```sh
   mkdir -p ~/Private/github.com/npx
   git clone https://github.com/npx/.dotfiles.git ~/Private/github.com/npx/.dotfiles
   cd ~/Private/github.com/npx/.dotfiles
   ```

4. **First switch** — `darwin-rebuild` doesn't exist yet, and neither do
   flakes-enablement or the machine's hostname, so all three are spelled out:

   ```sh
   sudo nix run nix-darwin/master#darwin-rebuild \
     --extra-experimental-features "nix-command flakes" \
     -- switch --flake .#MacBook-Pro
   ```

   This one command installs Homebrew itself (nix-homebrew), all casks and
   packages, dotfile symlinks, macOS defaults, the "vpn proxy" network
   location, and renames the machine — later rebuilds match the hostname
   automatically.

5. **Setup script** — the imperative leftovers nix deliberately doesn't own
   (node via fnm, claude CLI, `~/.secrets` template). Idempotent:

   ```sh
   ./setup
   ```

6. **Manual follow-ups** (by design, not omissions):
   - fill `~/.secrets` from the password manager
   - git identity is deliberately unset — git asks at the first commit;
     set it globally or per repo (work vs private)
   - TCC permission clicks: AeroSpace → Accessibility
   - App Store sign-in, login items
   - Mason LSP tools install themselves at first nvim launch

7. **Optional**: make bare `sudo darwin-rebuild switch` work without the
   `--flake` argument:

   ```sh
   sudo ln -s ~/Private/github.com/npx/.dotfiles /etc/nix-darwin
   ```

## Day to day

```sh
# apply nix-level changes (packages, modules, casks, defaults)
sudo darwin-rebuild switch --flake ~/Private/github.com/npx/.dotfiles
```

| Change | Where | Then |
| ------ | ----- | ---- |
| Edit an existing dotfile | edit it | nothing — symlinks are live |
| New CLI tool | `modules/home/core.nix` (both machines) or `dev.nix` (dev-only) | rebuild |
| New GUI app | `homebrew.casks` in `modules/darwin/default.nix` | rebuild |
| New top-level entry inside a package (e.g. `term/.config/newtool/`) | create it | `git add` it, then rebuild |
| New package dir | add it to a `stow [ ... ]` list in `modules/home/*.nix` | rebuild |

Standing exceptions: sketchybar is a brew formula (aerospace launches it via
PATH), claude is the native installer.

## Not managed here

- `~/.secrets` and `~/.gitconfig`-identity — machine-local, recreated by hand
- node versions — fnm, imperative (`~/.local/share/fnm`)
- VM images and their network settings — the UTM app is a cask, its
  contents are backed up separately
- switching network locations — manual (menu bar or `scselect`)
