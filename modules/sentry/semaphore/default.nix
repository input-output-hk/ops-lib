{ naersk
, fetchFromGitHub
, pkg-config
, openssl
, breakpointHook
}:

let
  json-forensics = fetchFromGitHub {
    owner = "getsentry";
    repo = "rust-json-forensics";
    rev = "3896ab98bae363570b7fc0e0af353f287ab17282";
    sha256 = "0vmqnqdh767gqxz2i0nlm5xyjg61fbn9370slrzzpkv9hpdprx5r";
  };
in

naersk.buildPackage {
  pname = "semaphore";
  version = "0.4.65";

  src = (fetchFromGitHub {
    owner = "getsentry";
    repo = "relay";
    rev = "refs/tags/0.4.65";
    sha256 = "13fqk7q77wymqrin2zifjp2xq46xb460qhcm4sbhy25a4bfzj9jq";
    fetchSubmodules = true;
  }).overrideAttrs(drv: {
    postFetch = drv.postFetch + ''
      # See commentary in patch
      patch --directory=$out --strip=1 < ${./semaphore.patch}

      # Copy over the json-forensics crate
      mkdir $out/json-forensics
      cp -r ${json-forensics}/* $out/json-forensics/
    '';
  });

  override = (drv: {
    preConfigure = ''
      # Kinda hacky, but this works to build the cabi dylib
      cd cabi
    '';
  });

  nativeBuildInputs = [ breakpointHook pkg-config openssl ];
}
