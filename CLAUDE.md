# ft-template — Developer Reference

## What this is

`ft-template` is the **clean starting point** for a new
[fast-track-nix](https://github.com/track-prepped-68-corolla/fast-track-nix)
consumer. Fork or copy it, rename the `example` machine and user, and you have
a working NixOS configuration managed by the framework.

It is `ft-testing` minus `tests/vm/` and `machines/strix-vm/` — the same
template configs and scripts, without the smoke-test infrastructure.

---

## Getting started

1. Fork or copy this repo.
2. Rename `machines/example/` to your machine name. Run `nixos-facter` on the
   target and replace `machines/<name>/var/facter.json`.
3. Edit `machines/<name>/modules/disko.nix` to match your real disk layout.
4. Rename `users/example/` to your username. Update `home.username` and git
   config in `users/<name>/default.nix`.
5. In `machines/<name>/default.nix` set `ft.users.mainUser`, `ft.users.superUsers`,
   and `ft.repoPath`.
6. Run `nix flake update ft-home` to pin the latest framework.
7. Deploy: `just bootstrap <name> <ip>`.

See `eject.md` for how to eject from ft-template and manage this repo long-term.

---

## Structure

```
flake.nix             # delegates to ft-home.lib.mkFlake inputs
machines/
  example/            # copy and rename to your machine name
    default.nix       # ft.* option toggles + identity
    modules/          # machine-local modules (disko.nix disk layout)
    var/facter.json   # hardware report — source of truth for system arch
users/
  example/            # copy and rename to your username
  guest/              # optional guest user
modules/
  home/default.nix   # empty consumer HM hub (kept so imports resolve)
scripts/              # ft CLI justfile recipes
```

No `modules/nixos/` — all NixOS modules live in `fast-track-nix`. If you need
a reusable NixOS module, open a PR there first.

---

## Hard rules

- **Never `nix flake update nixpkgs`** — nixpkgs follows the framework's pin.
  Update the framework (and nixpkgs with it): `nix flake update ft-home`.
- **Logic belongs in `fast-track-nix`.** This repo is configuration values, not
  code. Reusable modules go upstream.
- All PRs target `testing`, never `main`.
