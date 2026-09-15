# Dev profile — mac always; gaming host adds/removes this import at will.
{ config, lib, pkgs, ... }:
{
  home.file = import ./lib/stow.nix { inherit config lib; } [
    "nvim"
  ];

  home.packages = with pkgs; [
    neovim # needs >= 0.12 (vim.pack) — tracks nixpkgs-unstable
    tree-sitter # CLI; nvim-treesitter main branch compiles parsers with it
    direnv
    docker-compose # client only; the engine is Docker Desktop (cask) / NixOS virtualisation
    marp-cli
    uv
    fnm # node version manager (nvm workflow); versions live in ~/.local/share/fnm — node itself is imperative by design
  ];
}
