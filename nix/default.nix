{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
, sourcesOverride ? {} }:
let
  sourcePaths = import ./sources.nix { inherit pkgs; }
    // sourcesOverride;

  inherit (sourcePaths) nixpkgs;

  overlays = (import ../overlays sourcePaths false) ++
  [
    (import ../globals-deployers.nix)
  ];

  bootstrapPkgs = import nixpkgs {
    inherit config system crossSystem overlays;
  };

  nixpkgsPatched = bootstrapPkgs.runCommand "nixpkgs-patched" {} ''
    cp -r ${nixpkgs} $out
    chmod -R u+w $out

    cp ${../modules/virtualisation/amazon-ec2-amis.nix} $out/nixos/modules/virtualisation/amazon-ec2-amis.nix
    cp ${../modules/virtualisation/ec2-amis.nix} $out/nixos/modules/virtualisation/ec2-amis.nix
  '';

  pkgs = import nixpkgsPatched {
    inherit config system crossSystem overlays;
  };

in pkgs
