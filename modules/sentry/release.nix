{ pkgs ? import (import ../../nix/sources.nix).nixpkgs { overlays = []; } }:

let
  # callPackage = pkgs.lib.callPackageWith pkgs;
in
{
  sentry = pkgs.callPackage ./. {
    inherit (pkgs.python27Packages) buildPythonPackage fetchPypi;
  };

  inherit pkgs;
}

