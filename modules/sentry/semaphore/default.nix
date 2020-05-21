{ naersk
, breakpointHook
, rust-json-forensics
, fetchFromGitHub
, pkg-config
, openssl
}:

naersk.buildPackage rec {
  pname = "semaphore";
  version = "0.4.65";

  src = (fetchFromGitHub {
    owner = "getsentry";
    repo = "relay";
    rev = "refs/tags/0.4.65";
    sha256 = "1gj41c4kzqwz4pczkrqfrwa7mn35jbmp3jrfvck1ysgy54hqilbq";
    fetchSubmodules = true;
  }).overrideAttrs(drv: {
    postFetch = drv.postFetch + ''
      sed -i "s/\[workspace\]/[workspace]\nmembers = \[\"common\",\"general\",\"general\/derive\",\"server\"\]\n/g" $out/Cargo.toml
      cp ${./server/Cargo.toml} $out/server/Cargo.toml
      # sed -i "/json-forensics.*/d" $out/server/Cargo.toml
      # sed -i "/redis =.*/d" $out/server/Cargo.toml
      # substituteInPlace $out/server/Cargo.toml \
      #   --replace 'json-forensics = { version = "*", git = "https://github.com/getsentry/rust-json-forensics" }' \
      #             'json-forensics = { version = "0.1.0" }' \
      #   --replace 'redis = { git = "https://github.com/mitsuhiko/redis-rs", optional = true, branch = "feature/cluster", features = ["cluster", "r2d2"] }' \
      #             'redis = { version = "0.15.1", optional = true, features = ["cluster", "r2d2"] }'
      cat $out/Cargo.toml
      cat $out/server/Cargo.toml
    '';
  });

  nativeBuildInputs = [ breakpointHook pkg-config openssl ];

  override = (drv: {
    postConfigure = ''
      echo $CARGO_HOME
    '';
  });
}
