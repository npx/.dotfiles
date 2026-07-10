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

## Fresh NixOS (gaming desktop)

Same repo, host `desktop`. Boot the minimal ISO,
`sudo -i`, then:

1. **Partition + label** — labels are load-bearing if you keep the committed
   hardware config (device varies; the VM was `/dev/vda`):

   ```sh
   parted /dev/vda -- mklabel gpt
   parted /dev/vda -- mkpart ESP fat32 1MB 512MB
   parted /dev/vda -- set 1 esp on
   parted /dev/vda -- mkpart root ext4 512MB 100%
   mkfs.fat -F 32 -n boot /dev/vda1
   mkfs.ext4 -L nixos /dev/vda2
   mount /dev/disk/by-label/nixos /mnt
   mkdir -p /mnt/boot
   mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
   ```

2. **Clone to the load-bearing path**:

   ```sh
   nix-shell -p git
   mkdir -p /mnt/home/ybaron/Private/github.com/npx
   git clone https://github.com/npx/.dotfiles.git \
     /mnt/home/ybaron/Private/github.com/npx/.dotfiles
   ```

3. **Hardware config** — replace the committed placeholder with reality
   (commit it once the machine is online):

   ```sh
   nixos-generate-config --root /mnt --show-hardware-config \
     > /mnt/home/ybaron/Private/github.com/npx/.dotfiles/hosts/desktop/hardware-configuration.nix
   ```

4. **Install** (root stays locked; `ybaron` is wheel):

   ```sh
   nixos-install --root /mnt --no-root-passwd \
     --flake /mnt/home/ybaron/Private/github.com/npx/.dotfiles#desktop
   nixos-enter --root /mnt -c 'passwd ybaron'
   ```

5. **Reboot** without the ISO → tuigreet → pick `i3` (or the `steam`
   console session). First login:

   ```sh
   sudo chown -R ybaron: /home/ybaron/Private
   cd ~/Private/github.com/npx/.dotfiles && ./setup
   ```

   Then commit + push the hardware config.

## Day to day

```sh
# apply nix-level changes (packages, modules, casks, defaults)
sudo darwin-rebuild switch --flake ~/Private/github.com/npx/.dotfiles   # mac
sudo nixos-rebuild switch --flake ~/Private/github.com/npx/.dotfiles    # nixos
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
