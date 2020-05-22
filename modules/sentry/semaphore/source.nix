{ fetchFromGitHub }:

rec {
  json-forensics = fetchFromGitHub {
    owner = "getsentry";
    repo = "rust-json-forensics";
    rev = "3896ab98bae363570b7fc0e0af353f287ab17282";
    sha256 = "0vmqnqdh767gqxz2i0nlm5xyjg61fbn9370slrzzpkv9hpdprx5r";
  };

  semaphore = fetchFromGitHub {
    owner = "getsentry";
    repo = "relay";
    rev = "refs/tags/0.4.65";
    sha256 = "0f67l8c1dd96jlm8ppg9kg9w354smh80q3cy955zsakn3fx6x4lk";
    fetchSubmodules = true;
  };
}
