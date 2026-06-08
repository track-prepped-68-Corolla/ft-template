# Ejecting from ft-template

Once you've bootstrapped your NixOS config with ft-template, this file explains
your long-term relationship with the framework and how to handle edge cases.

---

## Normal workflow

You don't need to eject. The normal workflow is:

```
feature → testing → main
```

- All PRs target `testing`, never `main`.
- `nix flake update ft-home` updates the framework pin (and nixpkgs/home-manager
  with it, since they follow the framework).
- The CI workflow validates every push.

---

## Updating the framework pin

```bash
nix flake update ft-home
git add flake.lock
git commit -m "chore: update ft-home"
```

This updates `ft-home` and all its transitive inputs (nixpkgs, home-manager,
etc.) in one step. Never run `nix flake update nixpkgs` independently — nixpkgs
has no standalone pin here and follows the framework.

---

## Adding a machine

```bash
just add-machine <name> <ip>          # scaffolds machines/<name>/
nixos-facter > machines/<name>/var/facter.json   # on the target
# edit disko.nix, then:
just deploy <name> <ip>
```

---

## Adding a user

Create `users/<username>/default.nix`. The generator cross-products users with
all machine systems automatically — no registration needed.

---

## Machine-local modules

Put machine-specific NixOS config (disk layout, hardware quirks) under
`machines/<name>/modules/` and import it from that directory's `default.nix`.
Do not put reusable logic here; it belongs in `fast-track-nix`.

---

## True ejection (removing the framework dependency)

If you want to manage your NixOS config without fast-track-nix:

1. Run `nix eval .#nixosConfigurations.<name>.config --json` to see the final
   evaluated config for each machine.
2. Replace `ft-home.lib.mkFlake inputs` in `flake.nix` with a standard
   `lib.nixosSystem` call listing your modules explicitly.
3. Remove the `ft-home` input and replace `ft.*` options with their underlying
   NixOS equivalents.
4. Remove `modules/nixos/default.nix` and `modules/home/default.nix` (the
   framework hubs) and replace with explicit `imports`.

This is intentionally manual — the framework is designed to stay out of your way
so the underlying NixOS options are always accessible.
