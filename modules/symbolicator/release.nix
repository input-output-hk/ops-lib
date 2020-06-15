let
  sources = import ../../nix/sources.nix; 
  nixpkgs-mozilla = import sources.nixpkgs-mozilla;

  # Symbolicator requires rust >= 1.42.0
  overlays =  [
    nixpkgs-mozilla
    (self: super:
      let
        rustChannel = self.rustChannelOf { date = "2020-05-12"; channel = "nightly"; };
      in
      {
        rustc = rustChannel.rust;
        cargo = rustChannel.rust;
      }
    )
  ];
in

{ pkgs ? import ../../nix { overlays = overlays; }
}:

pkgs.callPackage ./default.nix { }
