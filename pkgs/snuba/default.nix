{ python
, iana-etc
, libredirect
, rdkafka
, lib
, fetchFromGitHub
, ncurses
, writeText
, glibcLocales
}:

let
  iohkMkPythonApplication = { python, overrides, ... }@attrs:
    let
      specialAttrs = [
        "overrides"
      ];
      passedAttrs = builtins.removeAttrs attrs specialAttrs;

      deps = map (depName: py.pkgs."${depName}") (builtins.attrNames (overrides {} {}));

      packageOverrides = lib.foldr lib.composeExtensions (self: super: {}) [overrides];

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

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "${pname}";
    rev = "refs/tags/${version}";
    sha256 = "0f59dvsw6q7azxgxfp9pwih2i5fxva0518vfnyh3zbfgjhmwgf07";
  };

  inherit python;
  # python = pkgs.python37;
  overrides = import ./overrides.nix { inherit lib iana-etc libredirect ncurses fetchFromGitHub writeText glibcLocales; };

  propagatedBuildInputs = [ rdkafka ];

  makeWrapperArgs = [ "--set PYTHONPATH $PYTHONPATH" ];

  postPatch = ''
    # Patch requirements.txt of snuba
    patch --strip=1 < ${./snuba.patch}
    # Pin dashboard web resource versions
    patch --strip=1 < ${./dashboard.patch}
    # Allow configuration of host and binding to addresses other than localhost
    patch --strip=1 < ${./configurable-host.patch}

    # Give proper path to Snuba README
    substituteInPlace snuba/web/views.py \
      --replace 'open("README.md")' 'open("'$out'/share/README.md")'
  '';

  preCheck = ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols
    export LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';
  postCheck = "unset NIX_REDIRECTS LD_PRELOAD";

  postInstall = ''
    mkdir $out/share
    cp README.md $out/share/
  '';

  doCheck = false;
}
