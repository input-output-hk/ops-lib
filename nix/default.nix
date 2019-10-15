{ sources ? import ./sources.nix
, system ? builtins.currentSystem
, crossSystem ? null
, config ? {} }:
import sources.nixpkgs {
  overlays = import ../overlays ++ [
    (_: super: super.mergeSources super sources)
  ];
  inherit system crossSystem config;
}
