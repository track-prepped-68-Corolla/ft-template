# =============================================================================
# ft-template — Minimal fast-track-nix Consumer Starter
# =============================================================================
#
# The clean starting point for a new fast-track-nix consumer:
#
#   1. machines/example  — copy and rename to your machine name. Replace
#      var/facter.json with a report from your hardware target.
#   2. users/example     — copy and rename to your username.
#   3. Rename the flake description and commit.
#
# `flake.nix` delegates all output generation to ft-home.lib.mkFlake, which
# auto-discovers machines/ and users/ and emits nixosConfigurations and
# homeConfigurations.
#
# Do NOT run `nix flake update nixpkgs` — nixpkgs follows the framework's pin.
# To update the framework (and nixpkgs with it): nix flake update ft-home.
# =============================================================================
{
  description = "My NixOS configuration";

  inputs = {
    # The fast-track-nix framework. Aliased as ft-home by consumer convention.
    ft-home.url = "github:track-prepped-68-corolla/fast-track-nix/testing";

    # Follow the framework's pins to avoid duplicate fetches and version drift.
    nixpkgs.follows = "ft-home/nixpkgs";
    home-manager.follows = "ft-home/home-manager";
    nixos-facter.follows = "ft-home/nixos-facter";
  };

  outputs =
    inputs@{ ft-home, ... }:
    ft-home.lib.mkFlake inputs;
}
