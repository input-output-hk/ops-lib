with import <nixpkgs> {};

pkgs.callPackage ../clusters/example.nix iohk-ops-lib.physical.libvirtd
