{ pkgs, system ? builtins.currentSystem }:

let
  rust-json-forensics = pkgs.callPackage ./rust-json-forensics {};

  rust-redis = pkgs.callPackage ./rust-redis {};

  rust-json-forensics-src = pkgs.fetchFromGitHub {
    owner = "getsentry";
    repo = "rust-json-forensics";
    rev = "3896ab98bae363570b7fc0e0af353f287ab17282";
    sha256 = "0vmqnqdh767gqxz2i0nlm5xyjg61fbn9370slrzzpkv9hpdprx5r";
  };

  rust-redis-src = pkgs.fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "redis-rs";
    rev = "refs/tags/0.15.1";
    sha256 = "01m06riirhy271x5y1kzib3rjw3a4bqb4smawdfzwsic7gm51as2";
  };

  semaphoreSrc = pkgs.fetchFromGitHub {
    owner = "getsentry";
    repo = "relay";
    rev = "refs/tags/0.4.65";
    sha256 = "0wxlkbsxn23gqx18mnmba512876ak01dq1rxka1bblzrqsv5iw0m";
    # fetchSubmodules = true;
    # postFetch = ''
    #   # ls -lah $out
    #   # sed -i "s/\[workspace\]/[workspace]\nmembers = \[\"common\",\]\n/g" Cargo.toml
    #   # cat Cargo.toml
    #   file
    #   substituteInPlace $out --replace ".toml" ".toml2"
    # '';
    extraPostFetch = ''
      sed -i "s/\[workspace\]/[workspace]\nmembers = \[\"common\",\"general\",\"general\/derive\",\"server\"\]\n/g" $out/Cargo.toml
      # Revision closest to date of release
      # Version of redis-rs including the no-longer existent "feature/cluster" branch
      substituteInPlace $out/server/Cargo.toml \
        --replace 'json-forensics = { version = "*", git = "https://github.com/getsentry/rust-json-forensics" }' \
                  'json-forensics = { path = "${rust-json-forensics-src}", version = "0.1.0" }' \
        --replace 'redis = { git = "https://github.com/mitsuhiko/redis-rs", optional = true, branch = "feature/cluster", features = ["cluster", "r2d2"] }' \
                  'redis = { path = "${rust-redis-src}", version = "0.15.1", optional = true, features = ["cluster", "r2d2"] }'
      cat $out/Cargo.toml
      cat $out/general/Cargo.toml
      cat $out/server/Cargo.toml
    '';
  };

  semaphoreRust = pkgs.naersk.buildPackage rec {
    pname = "semaphore";
    version = "0.4.65";
  
    src = semaphoreSrc;  

    nativeBuildInputs = [ pkgs.breakpointHook ];

    override = (drv: {
      postConfigure = ''
        echo $CARGO_HOME
      '';
    });
  };
in

self: super:

{
  amqp = self.buildPythonPackage rec {
    pname = "amqp";
    version = "1.4.9";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "06n6q0kxhjnbfz3vn8x9yz09lwmn1xi9d6wxp31h5jbks0b4vsid";
    };

    checkInputs = [ self.mock self.coverage self.nose-cover3 self.unittest2 ];
  };

  django-crispy-forms = self.buildPythonPackage rec {
    pname = "django-crispy-forms";
    version = "1.6.1";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1h7rgzg8f6wr5a5xqhfy8awss86ijqfp8rvc4b3fc6hi9sjg7568";
    };

    doCheck = false;
  };

  email_reply_parser = self.buildPythonPackage rec {
    pname = "email_reply_parser";
    version = "0.2.0";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0rlhsvs1ii93fq2774dn45gwfqgwx1f4fv4k27v1zr0h1zj9il1z";
    };
    # RuntimeError: dictionary changed size during iteration
    doCheck = false;
  };

  kombu = self.buildPythonPackage rec {
    pname = "kombu";
    version = "3.0.35";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "09xpxpjz9nk8d14dj361dqdwyjwda3jlf1a7v6jif9wn2xm37ar2";
    };

    propagatedBuildInputs = [ self.amqp self.anyjson ];
    checkInputs = [ self.mock self.unittest2 self.nose self.redis ];
  };

  googleapis_common_protos = super.googleapis_common_protos.overrideAttrs ( oldAttrs: rec {
    pname = "googleapis-common-protos";
    version = "1.6.0";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1im0ad5vdyjagy1hwp5xlw67l35i3griayvfgi46p5vbwgaqw6z6";
    };
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ self.protobuf ];
  });

  google_cloud_bigtable = super.google_cloud_bigtable.overrideAttrs ( oldAttrs: rec {
    pname = "google-cloud-bigtable";
    version = "0.32.2";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1gd857075xjxbb9b729qswd0a0gildrnw5z2s05zfa62160grla0";
    };
  });

  mmh3 = self.buildPythonPackage rec {
    pname = "mmh3";
    version = "2.3.1";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0a795lk2gqj5ar0diwpd0gsgycv83pwlr0a91fki2ch9giaw7bgc";
    };
  };

  parsimonious = super.parsimonious.overrideAttrs ( oldAttrs: rec {
    pname = "parsimonious";
    version = "0.8.0";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0sq81p00vsilvwyqpzp66vwbygp791bmyfii4hzp0mvf5bbnj25f";
    };
  });

  semaphore = self.buildPythonPackage rec {
    pname = "semaphore";
    version = "0.4.65";

    src = pkgs.fetchFromGitHub {
      owner = "getsentry";
      repo = "relay";
      rev = "refs/tags/0.4.65";
      sha256 = "14akjzilcda8ncfv73khngv64f9f7c7airjqyksvad89k5dnkfd5";
    };

    nativeBuildInputs = [ pkgs.breakpointHook pkgs.rustc pkgs.cargo self.setuptools semaphoreRust ];
    propagatedBuildInputs = [ self.milksnake pkgs.rustc pkgs.cargo self.setuptools semaphoreRust ];
    preBuild = ''
      set -euxo
      cd py
      # cp -f /nix/store/fscd8f71wmpwphcmi5mx8qnif2402x9m-run_setup.py nix_run_setup
      # exit 1
    '';
  };
}
