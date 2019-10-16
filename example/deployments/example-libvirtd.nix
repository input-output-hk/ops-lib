with import <nixpkgs> {};
import ../clusters/example.nix
  { inherit lib iohk-ops-lib pkgs; }
  iohk-ops-lib.physical.libvirtd
