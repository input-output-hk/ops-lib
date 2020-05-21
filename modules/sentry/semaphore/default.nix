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

naersk.buildPackage {
  pname = "semaphore";
  version = "0.4.65";

  src = (fetchFromGitHub {
    owner = "getsentry";
    repo = "relay";
    rev = "refs/tags/0.4.65";
    sha256 = "0ssyvdk8sklm7q3c08d8ycs4jd2bf7ln89rp10mfh9wl79qr4fdb";
    fetchSubmodules = true;
  }).overrideAttrs(drv: {
    postFetch = drv.postFetch + ''
      # See commentary in patch
      patch --directory=$out --strip=1 < ${./semaphore.patch}

      # Copy over the json-forensics crate
      mkdir $out/server/json-forensics
      cp -r ${json-forensics}/* $out/server/json-forensics
    '';
  });

  nativeBuildInputs = [ pkg-config openssl ];
}
