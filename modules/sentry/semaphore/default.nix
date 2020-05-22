{ naersk
, fetchFromGitHub
, pkg-config
, openssl
}:

let
  json-forensics = fetchFromGitHub {
    owner = "getsentry";
    repo = "rust-json-forensics";
    rev = "3896ab98bae363570b7fc0e0af353f287ab17282";
    sha256 = "0vmqnqdh767gqxz2i0nlm5xyjg61fbn9370slrzzpkv9hpdprx5r";
  };
in

naersk.buildPackage rec {
  pname = "semaphore";
  version = "0.4.65";

  src = (fetchFromGitHub {
    owner = "getsentry";
    repo = "relay";
    rev = "refs/tags/0.4.65";
    sha256 = "0f67l8c1dd96jlm8ppg9kg9w354smh80q3cy955zsakn3fx6x4lk";
    fetchSubmodules = true;
  }).overrideAttrs(drv: {
    postFetch = drv.postFetch + ''
      # See commentary in patch
      patch --directory=$out --strip=1 < ${./semaphore.patch}

      # Copy over the json-forensics crate
      cp -r ${json-forensics} $out/json-forensics
    '';
  });

  override = (drv: {
    preConfigure = ''
      # Kinda hacky, but this works to build the cabi dylib with all
      # the dependencies from the root project.
      cd cabi
    '';

    postInstall = ''
      cp -r ${src}/cabi/include $out/include
    '';
  });

  nativeBuildInputs = [ pkg-config openssl ];
}
