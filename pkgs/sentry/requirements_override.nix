{ pkgs, python }:

self: super: {
  xmlsec = python.mkDerivation rec {
    pname = "xmlsec";
    version = "1.3.8";

    src = pkgs.python.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "1ki5jiws8r9sbdbbn5cw058m57rhx42g91rrsa2bblqwngi3z546";
    };

    buildInputs = with pkgs; [ libtool.lib zlib xmlsec.dev xmlsec ];
    propagatedBuildInputs = with pkgs; [ self.lxml self.pkgconfig self.pathlib2 self."setuptools-scm" self.toml xmlsec.dev xmlsec ];

    # checkInputs = with pkgs; [ pytest xmlsec.dev xmlsec hypothesis ];
    doCheck = false;
    postPatch = ''
      patch --strip=1 < ${./xmlsec/lxml-workaround.patch}
      patch --strip=1 < ${./xmlsec/no-black-format.patch}
    '';

    LD_LIBRARY_PATH = "${pkgs.xmlsec}/lib";
    PKG_CONFIG_PATH = "${pkgs.xmlsec.dev}/lib/pkgconfig:${pkgs.libxml2.dev}/lib/pkgconfig:${pkgs.libxslt.dev}/lib/pkgconfig:$PKG_CONFIG_PATH";
  };

  python3-saml =
    let
      fix2020Patch = pkgs.fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/onelogin/python3-saml/pull/140.patch";
        sha256 = "0pm40kszv5qcnkw3ksz6c68zkqibakaxdggkxfadiasw9ys91nl6";
      };
      fixCertValue = pkgs.fetchpatch {
        url = "https://github.com/onelogin/python3-saml/commit/771072e2ae1380acde4ec6af2d7b46b96dccfd2d.patch";
        sha256 = "0yplwcpb5ksxgbfnmmxssj4c9ak1g1p6hfj8nfh2ybrmbk38n2f8";
      };
    in
      python.mkDerivation rec {
        pname = "python3-saml";
        version = "1.4.0";

        buildInputs = [];

        # Fetch from GitHub because PyPi doesn't have tests available in src
        src = pkgs.fetchFromGitHub {
          owner = "onelogin";
          repo = "${pname}";
          rev = "refs/tags/v${version}";
          sha256 = "05l63qwfqvw67v70bsam76amxpz7hnkqn8329yrds3fzgzkhkqrl";
        };

        postPatch = ''
          patch --strip=1 < ${fix2020Patch}
          patch --strip=1 < ${fixCertValue}
        '';

        propagatedBuildInputs = with self; [ defusedxml xmlsec isodate ];

        LD_LIBRARY_PATH = "${pkgs.xmlsec}/lib";

        doCheck = false;
      };

  pillow = pkgs.python.pkgs.pillow.overrideAttrs (oldAttrs: rec {
    pname = "Pillow";
    version = "6.2.1";

    src = pkgs.python.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "1c8wkzc58f5wdh006jvmwdk3wxld1xgagcbdvj7iv17qi0m9fkmz";
    };

    doCheck = false;
  });

  semaphore = pkgs.python.pkgs.callPackage ./semaphore { };

  symbolic = pkgs.python.pkgs.callPackage ./symbolic { };

  "jsonschema" = python.overrideDerivation super."jsonschema" (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ self.vcversioner ];
  });

  "progressbar2" = python.overrideDerivation super."progressbar2" (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ self.pytest-runner ];
  });

  "ua-parser" = python.overrideDerivation super."ua-parser" (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ self.pyyaml ];
  });

  defusedxml = python.mkDerivation rec {
    pname = "defusedxml";
    version = "0.5.0";

    buildInputs = [];

    src = pkgs.python.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "1x54n0h8hl92vvwyymx883fbqpqjwn2mc8fb383bcg3z9zwz5mr4";
    };
  };

  pkgconfig = python.mkDerivation rec {
    pname = "pkgconfig";
    version = "1.5.1";

    setupHook = pkgs.pkgconfig.setupHook;

    src = pkgs.python.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "97bfe3d981bab675d5ea3ef259045d7919c93897db7d3b59d4e8593cba8d354f";
    };

    nativeBuildInputs = [ pkgs.pkgconfig ];

    doCheck = false;

    buildInputs = [];
    patches = [ ./executable.patch ];
    postPatch = ''
      substituteInPlace pkgconfig/pkgconfig.py --replace 'PKG_CONFIG_EXE = "pkg-config"' 'PKG_CONFIG_EXE = "${pkgs.pkgconfig}/bin/pkg-config"'
    '';

    meta = with pkgs.lib; {
      description = "Interface Python with pkg-config";
      homepage = "https://github.com/matze/pkgconfig";
      license = licenses.mit;
    };
  };

  uwsgi = null;
}
