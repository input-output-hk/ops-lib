{ fetchFromGitHub }:

rec {
  apple-crash-report-parser = fetchFromGitHub {
    owner = "getsentry";
    repo = "apple-crash-report-parser";
    rev = "refs/tags/0.4.0";
    sha256 = "0wy1hgz62cv17gwl9gxpk5idy2d2w96mnvw6h2w2wa5wj9zflvb8";
  };

  symbolic = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolic";
    rev = "refs/tags/7.2.0";
    sha256 = "0400hvnrg60ynjx8vkiyzm95izjzldifn26ifzx8z3h9a9iriyzg";
    fetchSubmodules = true;
  };
}
