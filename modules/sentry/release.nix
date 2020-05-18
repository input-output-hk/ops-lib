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
{
  sentry = pkgs.callPackage ./. {
    inherit (py.pkgs) buildPythonPackage fetchPypi googleapis_common_protos;
  };

  sentryNew = iohkMkPythonApplication rec {
    pname   = "sentry";
    version = "10.0.0";
    format = "wheel";

    src = python.pkgs.fetchPypi {
      inherit pname version format;
      sha256 = "2695ed1cf11e5afee92de04dc1868de9f4c49d5876c34579c935d9d6cf9fbb03";
      python = "py27";
    };

    python = pkgs.python;
    overrides = overlay;
  };

  inherit py pkgs;

  semaphoreSrc = pkgs.fetchFromGitHub {
    owner = "getsentry";
    repo = "relay";
    rev = "refs/tags/0.4.65";
    sha256 = "14akjzilcda8ncfv73khngv64f9f7c7airjqyksvad89k5dnkfd5";
    postFetch = ''
      sed -i "s/\[workspace\]/[workspace]\nmembers = \[\"common\"\]\n/g" Cargo.toml
      cat Cargo.toml
    '';
  };
}


