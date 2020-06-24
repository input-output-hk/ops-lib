{ buildPythonPackage
, fetchFromGitHub
, rust-symbolic
, milksnake
}:

let
  sources = import ./source.nix { inherit fetchFromGitHub; };
in
buildPythonPackage rec {
  pname = "symbolic";
  version = "7.2.0";

  src = sources.symbolic;

  postPatch = ''
    patch --strip=1 < ${./python.patch}
    substituteInPlace py/setup.py \
      --replace '@nixBuildDylib@' '${rust-symbolic}/lib/libsymbolic.so' \
      --replace '@nixBuildHeader@' '${rust-symbolic}/include/symbolic.h'
  '';

  nativeBuildInputs = [ milksnake rust-symbolic ];

  preBuild = ''
    cd py
  '';
}
