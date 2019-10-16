{ sources ? import ../../nix/sources.nix // { ops-lib = ../..; }
, system ? builtins.currentSystem
, crossSystem ? null
, config ? {} }:
import sources.nixpkgs {
  overlays = (import sources.ops-lib {}).overlays
    ++ import ../overlays
    ++ [
      (_: super: super.mergeSources super sources)
      (import ../globals.nix)
    ];
  inherit system crossSystem config;
}
