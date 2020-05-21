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
      sed -i "s/\[workspace\]/[workspace]\nmembers = \[\"common\",\"general\",\"general\/derive\",\"server\",\"server\/json-forensics\"\]\n/g" $out/Cargo.toml
      cp ${./server/Cargo.toml} $out/server/Cargo.toml
      mkdir $out/server/json-forensics
      cp -r ${patched.json-forensics}/* $out/server/json-forensics
      # sed -i "/json-forensics.*/d" $out/server/Cargo.toml
      # sed -i "/redis =.*/d" $out/server/Cargo.toml
      # substituteInPlace $out/server/Cargo.toml \
      #   --replace 'json-forensics = { version = "*", git = "https://github.com/getsentry/rust-json-forensics" }' \
      #             'json-forensics = { version = "0.1.0" }' \
      #   --replace 'redis = { git = "https://github.com/mitsuhiko/redis-rs", optional = true, branch = "feature/cluster", features = ["cluster", "r2d2"] }' \
      #             'redis = { version = "0.15.1", optional = true, features = ["cluster", "r2d2"] }'
      cat $out/Cargo.toml
      cat $out/server/Cargo.toml
      ls -lah $out
      ls -lah $out/server/json-forensics
    '';
  });

  nativeBuildInputs = [ breakpointHook pkg-config openssl ];

  override = (drv: {
    postConfigure = ''
      echo $CARGO_HOME
    '';
  });
}
