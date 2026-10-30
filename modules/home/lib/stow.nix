# Pure stow replica.
#
# Enumerates a package's files from the flake's own source tree (the
# git-tracked store copy — pure, no --impure) but links every entry
# OUT-OF-STORE to the live repo path, so edits apply instantly and never
# need a rebuild. Directories are linked whole (stow "tree folding"):
# new files inside a linked directory appear immediately.
#
# "Container" directories are shared between packages (and with other
# software), so they are merged — we recurse into them and link their
# children instead of linking the container itself.
#
# Consequences:
#   - editing / adding files inside a linked dir: nothing to do, live
#   - brand-new top-level entry in a package: `git add` + rebuild
#   - untracked files (e.g. term/.secrets) are invisible here — on purpose
#
# Returns { link, unfold }: link turns a list of packages into home.file,
# unfold is the activation step that keeps the two link styles from
# colliding (see there); one module sets it for all.
{ config, lib }:
let
  repoRoot = ../../..; # flake root; used for enumeration only
  dotfilesDir = "${config.home.homeDirectory}/Private/github.com/npx/.dotfiles";
  # INVARIANT: every ancestor of a nested container must itself be listed
  # (e.g. "Library" for "Library/Application Support") — the walk only
  # consults this list for paths it has already recursed into. A missing
  # ancestor silently links the ancestor dir wholesale.
  # ".bin" is merged so that wm-linux can add desktop-only scripts next to
  # term's; the price is that a brand-new script needs `git add` + rebuild.
  containers = [ ".bin" ".config" "Library" "Library/Application Support" ];

  walk = pkg: rel:
    let
      dir = repoRoot + "/${pkg}${lib.optionalString (rel != "") "/${rel}"}";
      entry = name: type:
        let relPath = if rel == "" then name else "${rel}/${name}";
        in
        if type == "directory" && lib.elem relPath containers then
          walk pkg relPath
        else {
          ${relPath}.source =
            config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${pkg}/${relPath}";
        };
    in
    lib.foldl' lib.mergeAttrs { } (lib.mapAttrsToList entry (builtins.readDir dir));
in
{
  # Merge all packages; fail loudly (like stow does) if two packages ever
  # provide the same target instead of silently letting the last one win.
  link = packages:
    lib.mapAttrs
      (target: values:
        if lib.length values == 1 then
          lib.head values
        else
          throw "stow.nix: target '${target}' provided by multiple packages")
      (lib.zipAttrs (map (pkg: walk pkg "") packages));

  # Stow's "unfolding": a directory an earlier generation linked whole
  # (~/.bin -> store -> repo) that is now a container must lose that link
  # before home-manager links the children. Left in place, home-manager
  # follows it into the live repo, takes the repo's own files for files in
  # the way, moves them to *.hm-backup and puts store links in their place
  # (it happened). Only our links go: a symlink into the store is
  # home-manager's; anything else stays for its own collision check,
  # checkLinkTargets, which runs right after this. The reverse move
  # (container back to one link) needs nothing: a real directory in the
  # way makes that check abort, loudly.
  unfold = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    for c in ${lib.escapeShellArgs containers}; do
      t="${config.home.homeDirectory}/$c"
      if [[ -L $t && $(readlink "$t") == /nix/store/* ]]; then
        run rm $VERBOSE_ARG "$t"
      fi
    done
  '';
}
