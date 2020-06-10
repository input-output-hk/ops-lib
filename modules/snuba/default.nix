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

iohkMkPythonApplication rec {
  pname   = "snuba";
  version = "10.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "getsentry";
    repo = "${pname}";
    rev = "refs/tags/${version}";
    sha256 = "0f59dvsw6q7azxgxfp9pwih2i5fxva0518vfnyh3zbfgjhmwgf07";
  };

  python = pkgs.python37;
  overrides = overlay;

  propagatedBuildInputs = [ pkgs.rdkafka ];

  makeWrapperArgs = [ "--set PYTHONPATH $PYTHONPATH" ];

  postPatch = ''
    patch --strip=1 < ${./snuba.patch}
    patch --strip=1 < ${./dashboard.patch}
  '';

  preCheck = ''
    export NIX_REDIRECTS=/etc/protocols=${pkgs.iana-etc}/etc/protocols
    export LD_PRELOAD=${pkgs.libredirect}/lib/libredirect.so
  '';
  postCheck = "unset NIX_REDIRECTS LD_PRELOAD";

  doCheck = false;
}
