{ naersk, fetchFromGitHub, breakpointHook }:

naersk.buildPackage rec {
  pname = "json-forensics";
  version = "0.1.0";

  nativeBuildInputs = [ breakpointHook ];

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "rust-json-forensics";
    rev = "3896ab98bae363570b7fc0e0af353f287ab17282";
    sha256 = "1ywdbpwik9q9i429wxwlx1sydv2cbyrxf40ja2gii27nz7z3qrw1";
    extraPostFetch = ''
      cp ${./Cargo.lock} $out/Cargo.lock
      cat $out/Cargo.lock
    '';
  };

  override = (drv: {
    preBuild = ''
      exit 1
    '';
  });
}
