{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
, sourcesOverride ? {} }:
let
  sourcePaths = import ./sources.nix { inherit pkgs; }
    // sourcesOverride;

  iohkNix = import sourcePaths.iohk-nix {};

  # Use our own nixpkgs if it exists in our sources,
  # otherwise use iohkNix default nixpkgs.
  nixpkgs = if (sourcePaths ? nixpkgs)
    then sourcePaths.nixpkgs
    else iohkNix.nixpkgs;

  flake-compat = import sourcePaths.flake-compat;

  overlays = (import ../overlays sourcePaths false) ++
  [
    (import ../globals-deployers.nix)
    (final: prev: {
      nix = (flake-compat {inherit pkgs; src = sourcePaths.nixpkgs;}).defaultNix.legacyPackages.${final.system}.nixVersions.nix_2_29;
    })
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
