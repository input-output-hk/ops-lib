{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
}:
let
  sourcePaths = import ./sources.nix { inherit pkgs; };

  # use our own nixpkgs if it exists in our sources,
  # otherwise use iohkNix default nixpkgs.
  nixpkgs = if (sourcePaths ? nixpkgs)
    then sourcePaths.nixpkgs
    else (import sourcePaths.iohk-nix {}).nixpkgs;

  iohkNix = import sourcePaths.iohk-nix {};

  # overlays from ops-lib (include ops-lib sourcePaths):
  ops-lib-overlays = (import sourcePaths.ops-lib {}).overlays;

  overlays = ops-lib-overlays ++ [
    (self: super: { iohkNix = import sourcePaths.iohk-nix {};})
  ];

  pkgs = import nixpkgs {
    inherit system crossSystem config overlays;
  };
in
  pkgs

