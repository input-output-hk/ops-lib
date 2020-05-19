{ naersk, fetchFromGitHub }:

naersk.buildPackage rec {
  pname = "redis";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "redis-rs";
    rev = "refs/tags/0.15.1";
    sha256 = "08r3l7my9v6gz41vcvnwrc2x682lzr3vs69p3rf5nlv354p2nz99";
    extraPostFetch = ''
      cp ${./Cargo.lock} $out/Cargo.lock
      cat $out/Cargo.lock
    '';
  };
}
