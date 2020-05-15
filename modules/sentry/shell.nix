{ pkgs ? import ../../nix {} }:

let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix/";
    ref = "master";
    rev = "9cdd2b74eed3047b85219ab690172dedc21895f9";
  });
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    mach-nix.mach-nix
    nix
    git
  ];
}
