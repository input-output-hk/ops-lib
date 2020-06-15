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
  nixpkgs-mozilla = import sourcePaths.nixpkgs-mozilla;

  # overlays from ops-lib (include ops-lib sourcePaths):
  ops-lib-overlays = (import sourcePaths.ops-lib {}).overlays;

  overlays = [
    nixpkgs-mozilla
    (self: super:
    let
      rustChannel = self.rustChannelOf { date = "2020-05-12"; channel = "nightly"; };
    in
      {
        inherit iohkNix;
        naersk = import sourcePaths.naersk {};
        rustc = rustChannel.rust;
        cargo = rustChannel.rust;
      }
    )
  ];

  pkgs = import nixpkgs {
    inherit system crossSystem config overlays;
  };
in
  pkgs

