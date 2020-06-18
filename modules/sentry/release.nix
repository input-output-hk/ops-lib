{ pkgs ? import ../../nix {} }:

let

  overlay = import ./overrides.nix { inherit pkgs; };

  packageOverrides = pkgs.lib.foldr pkgs.lib.composeExtensions (self: super: {}) [overlay];

  py = pkgs.python.override { inherit packageOverrides; self = py; };

  iohkMkPythonApplication = { python, overrides, ... }@attrs:
    let
      specialAttrs = [
        "overrides"
      ];
      passedAttrs = builtins.removeAttrs attrs specialAttrs;

      deps = map (depName: py.pkgs."${depName}") (builtins.attrNames (overrides {} {}));

      packageOverrides = pkgs.lib.foldr pkgs.lib.composeExtensions (self: super: {}) [overrides];

      py = python.override { inherit packageOverrides; self = py; };
    in
      python.pkgs.buildPythonApplication (
        passedAttrs // {
          propagatedBuildInputs = (attrs.propagatedBuildInputs or []) ++ deps;
        }
      );
in
rec {
  sentry = import ./default.nix { };

  inherit py pkgs;

  semaphore = pkgs.callPackage ./semaphore { };
}


