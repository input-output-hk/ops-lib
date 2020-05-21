{ naersk
, breakpointHook
, rust-json-forensics
, fetchFromGitHub
, pkg-config
, openssl
}:

let
  patched = rec {
    json-forensics = fetchFromGitHub {
      owner = "getsentry";
      repo = "rust-json-forensics";
      rev = "3896ab98bae363570b7fc0e0af353f287ab17282";
      sha256 = "0vmqnqdh767gqxz2i0nlm5xyjg61fbn9370slrzzpkv9hpdprx5r";
    };
  };
in

naersk.buildPackage rec {
  pname = "semaphore";
  version = "0.4.65";

  src = (fetchFromGitHub {
    owner = "getsentry";
    repo = "relay";
    rev = "refs/tags/0.4.65";
    sha256 = "1yxjrr70bw6953ykyhj1ij4s66yr25k22v0bbincn8fh76x9nw5a";
    fetchSubmodules = true;
  }).overrideAttrs(drv: {
    postFetch = drv.postFetch + ''
      # Add the local libraries to the workspace, required by naersk,
      # probably good practice anyway
      sed -i "s/\[workspace\]/[workspace]\nmembers = \[\"common\",\"general\",\"general\/derive\",\"server\",\"server\/json-forensics\"\]\n/g" $out/Cargo.toml

      # Modify the server packages Cargo.toml to use a local version
      # of json-forensics. If we try to use the Git version, it will
      # fail due to not having a lock file present in the git repo:
      # "the source ... requires a lock file to be present first
      # before it can be used against vendored source code"
      cp ${./server/Cargo.toml} $out/server/Cargo.toml
      mkdir $out/server/json-forensics
      cp -r ${patched.json-forensics}/* $out/server/json-forensics
    '';
  });

  nativeBuildInputs = [ breakpointHook pkg-config openssl ];

  override = (drv: {
    postConfigure = ''
      echo $CARGO_HOME
    '';
  });
}
