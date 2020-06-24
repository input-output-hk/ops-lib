{ pkgs }:

let
  python = import ./requirements.nix { inherit pkgs; };

  django_1_11_patch = pkgs.fetchpatch {
    url = "https://github.com/getsentry/sentry/commit/e171b81e66f65825d4f9f38db2cc91d8927621b3.patch";
    sha256 = "0dzlhal08wdhlasw8pkr2i0sl4kf4bmn4zfx0c6zm9kn26rar6hz";
    excludes = [ ".travis.yml" ];
  };
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
    # Unset SOURCE_DATE_EPOCH: ZIP requires timestamps >= 1980
    # https://nixos.org/nixpkgs/manual/#python-setup.py-bdist_wheel-cannot-create-.whl
    unset SOURCE_DATE_EPOCH
    pushd dist
    wheel_file=sentry-10.0.0-py27-none-any.whl
    wheel unpack $wheel_file
    rm $wheel_file
    # Remove uwsgi dependency
    sed -i '/.*uwsgi.*/d' sentry-10.0.0/sentry-10.0.0.dist-info/METADATA
    # Jailbreak
    sed -i 's/.*PyYAML.*/Requires-Dist: PyYAML/' sentry-10.0.0/sentry-10.0.0.dist-info/METADATA
    sed -i 's/.*Django.*/Requires-Dist: Django/' sentry-10.0.0/sentry-10.0.0.dist-info/METADATA
    sed -i 's/.*djangorestframework.*/Requires-Dist: djangorestframework/' sentry-10.0.0/sentry-10.0.0.dist-info/METADATA
    # Allow new Django version to work
    patch --strip 2 --directory sentry-10.0.0/ < ${django_1_11_patch}
    wheel pack ./sentry-10.0.0
    rm -r sentry-10.0.0
    popd
  '';
})
