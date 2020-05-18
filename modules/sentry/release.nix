{ pkgs ? import ../../nix {} }:

let
  overlay = import ./overrides.nix { inherit pkgs; };

  packageOverrides = pkgs.lib.foldr pkgs.lib.composeExtensions (self: super: {}) [overlay];

  py = pkgs.python.override { inherit packageOverrides; self = py; };
in
{
  sentry = pkgs.callPackage ./. {
    inherit (py.pkgs) buildPythonPackage fetchPypi;
    python = py;
  };

  inherit py pkgs;
}

