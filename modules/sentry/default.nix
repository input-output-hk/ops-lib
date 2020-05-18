{ lib
, buildPythonPackage
, writeText
, stdenv
, git
, nodejs
, yarn
, fetchPypi
, googleapis_common_protos
}:

let
  sharedLibraryExt = stdenv.hostPlatform.extensions.sharedLibrary;

  noNixFilter = name: type:
    let
      baseName = baseNameOf (toString name);
    in
      !(lib.hasSuffix ".nix" baseName);
in

buildPythonPackage rec {
  pname   = "sentry";
  version = "10.0.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "2695ed1cf11e5afee92de04dc1868de9f4c49d5876c34579c935d9d6cf9fbb03";
    python = "py27";
  };

  # nativeBuildInputs = [ googleapis_common_protos ];
  # buildInputs = [  googleapis_common_protos ];
  propagatedBuildInputs = [ googleapis_common_protos ];

  preInstall = ''
    set -euxo
  '';

  # postInstall = ''
  #   cp ${monero_burn}/lib/libmoneroburn${sharedLibraryExt} $out/lib/python3.7/site-packages/monero_burn/moneroburn${sharedLibraryExt}
  # '';
}
