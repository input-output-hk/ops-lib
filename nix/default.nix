{ sourcePaths ? import ./sources.nix
, system ? builtins.currentSystem
, crossSystem ? null
, config ? {} }:
import sourcePaths.nixpkgs {
  overlays = (import ../overlays sourcePaths) ++
    [ (import ../globals-deployers.nix) ];
  inherit system crossSystem config;
}
