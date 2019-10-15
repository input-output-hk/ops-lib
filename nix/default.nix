{ sources ? import ./sources.nix
, system ? builtins.currentSystem
, crossSystem ? null
, config ? {} }:
import sources.nixpkgs {
  overlays = import ../overlays ++ [
    (_: super: super.mkSourcesOverlay super sources)
  ];
  inherit system config;
}
