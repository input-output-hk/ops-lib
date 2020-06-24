{ pkgs }:

let
  python = import ./requirements.nix { inherit pkgs; };
in

python.mkDerivation rec {
  pname   = "snuba";
  version = "10.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "getsentry";
    repo = "${pname}";
    rev = "refs/tags/${version}";
    sha256 = "0f59dvsw6q7azxgxfp9pwih2i5fxva0518vfnyh3zbfgjhmwgf07";
  };

  buildInputs = [];
  propagatedBuildInputs = builtins.attrValues python.packages;

  makeWrapperArgs = [ "--set PYTHONPATH $PYTHONPATH" ];

  postPatch = ''
    # Patch requirements.txt of snuba
    substituteInPlace requirements.txt \
      --replace 'appnope==0.1.0' "appnope==0.1.0; sys_platform == 'darwin'" \
      --replace 'enum34==1.1.6' "enum34==1.1.6; python_version <= '3.4'" \
      --replace 'flake8==3.7.8' 'flake8' \
      --replace 'jedi==0.12.0' 'jedi' \
      --replace 'parso==0.2.1' 'parso'

    # Pin dashboard web resource versions
    patch --strip=1 < ${./dashboard.patch}

    # Allow configuration of host and binding to addresses other than localhost
    patch --strip=1 < ${./configurable-host.patch}

    # Give proper path to Snuba README
    substituteInPlace snuba/web/views.py \
      --replace 'open("README.md")' 'open("'$out'/share/README.md")'
  '';

  preCheck = ''
    export NIX_REDIRECTS=/etc/protocols=${pkgs.iana-etc}/etc/protocols
    export LD_PRELOAD=${pkgs.libredirect}/lib/libredirect.so
  '';
  postCheck = "unset NIX_REDIRECTS LD_PRELOAD";

  postInstall = ''
    mkdir $out/share
    cp README.md $out/share/
  '';

  doCheck = false;
}
