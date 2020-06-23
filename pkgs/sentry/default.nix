{ pkgs }:

let
  python = import ./requirements.nix { inherit pkgs; };
in

(python.mkDerivation rec {
  pname   = "sentry";
  version = "10.0.0";
  format = "wheel";

  src = pkgs.python.pkgs.fetchPypi {
    inherit pname version format;
    sha256 = "2695ed1cf11e5afee92de04dc1868de9f4c49d5876c34579c935d9d6cf9fbb03";
    python = "py27";
  };

  buildInputs = [];

  propagatedBuildInputs = builtins.attrValues python.packages;

  makeWrapperArgs = ["--set PYTHONPATH $PYTHONPATH" "--set LD_LIBRARY_PATH ${pkgs.xmlsec}/lib" ];

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
})
