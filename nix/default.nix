{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
, sourcesOverride ? {} }:
let
  sourcePaths = import ./sources.nix { inherit pkgs; }
    // sourcesOverride;

  iohkNix = import sourcePaths.iohk-nix {};

  # use our own nixpkgs if it exists in our sources,
  # otherwise use iohkNix default nixpkgs.
  nixpkgs = if (sourcePaths ? nixpkgs)
    then sourcePaths.nixpkgs
    else iohkNix.nixpkgs;

  flake-compat = import sourcePaths.flake-compat;

  overlays = (import ../overlays sourcePaths false) ++
  [
    (import ../globals-deployers.nix)
    (final: prev: {
      # A recent version of nix daemon is required to be able to migrate to newer nixpkgs, such as 25.05,
      # otherwise an `error: path '/nix/store/...-linux-$VERSION-modules-shrunk/lib` is encountered during build.
      nix = (builtins.getFlake "github:nixos/nix/9328af84d33281ef8018251b2a4289e89719c7ae").packages.${final.system}.nix;
    })
  ];

  pkgs = import nixpkgs {
    inherit config system crossSystem overlays;
  };

in pkgs
