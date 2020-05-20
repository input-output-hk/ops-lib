{ naersk, fetchFromGitHub, breakpointHook }:

naersk.buildPackage rec {
  pname = "json-forensics";
  version = "0.1.0";

  nativeBuildInputs = [ breakpointHook ];

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "rust-json-forensics";
    rev = "3896ab98bae363570b7fc0e0af353f287ab17282";
    sha256 = "sha256-Z8i58ENIR15yX83wOD8TNsZVF/LIzzgYEoXAauFPX9c=";
    extraPostFetch = ''
      cp ${./Cargo.lock} $out/Cargo.lock
      cp ${./Cargo.toml} $out/Cargo.toml
    '';
  };
}
