{ buildPythonPackage
, fetchFromGitHub
, rust-semaphore
, milksnake
}:

buildPythonPackage rec {
  pname = "semaphore";
  version = "0.4.65";

  src = (import ./source.nix { inherit fetchFromGitHub; }).semaphore;

  postPatch = ''
    patch --strip=1 < ${./setup-py.patch}
    substituteInPlace py/setup.py \
      --replace '@nixBuildDylib@' '${rust-semaphore}/lib/libsemaphore.so' \
      --replace '@nixBuildHeader@' '${rust-semaphore}/include/semaphore.h'
  '';

  nativeBuildInputs = [ milksnake rust-semaphore ];

  preBuild = ''
    cd py
  '';
}
