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
  sentry = (iohkMkPythonApplication rec {
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

    nativeBuildInputs = [ pkgs.breakpointHook ];
    propagatedBuildInputs = [ python.pkgs.setuptools ];

  }).overrideAttrs(drv: {
    buildPhase = ''
      # Remove uwsgi dependency

      # Unset SOURCE_DATE_EPOCH: ZIP requires timestamps >= 1980
      # https://nixos.org/nixpkgs/manual/#python-setup.py-bdist_wheel-cannot-create-.whl
      unset SOURCE_DATE_EPOCH
      pushd dist
      wheel_file=sentry-10.0.0-py27-none-any.whl
      wheel unpack $wheel_file
      rm $wheel_file
      sed -i '/.*uwsgi.*/d' sentry-10.0.0/sentry-10.0.0.dist-info/METADATA
      wheel pack ./sentry-10.0.0
      rm -r sentry-10.0.0
      popd
    '';
  });

  inherit py pkgs;

  semaphore = pkgs.callPackage ./semaphore { };
}


