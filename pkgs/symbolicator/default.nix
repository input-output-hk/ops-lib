{ naersk
, fetchFromGitHub
, pkg-config
, openssl
}:

naersk.buildPackage rec {
  pname = "symbolicator";
  version = "0.1.0";

  # Generate these by executing these commands in a local checkout of
  # symbolicator:
  # git describe --always --dirty=-modified
  SYMBOLICATOR_GIT_VERSION = "0.1.0-145-g8ac8f40";
  # git rev-parse HEAD
  SYMBOLICATOR_RELEASE = "8ac8f400fb7416c6c46fad856cdba2bc70c27c6c";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolicator";
    rev = "8ac8f400fb7416c6c46fad856cdba2bc70c27c6c";
    sha256 = "10n4g129nfg211jvq3k6xyi1drvk6z0lnc2ml1rkqib49c6gdr31";
  };

  nativeBuildInputs = [ pkg-config openssl ];
}
