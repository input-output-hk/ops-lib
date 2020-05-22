{ pkgs, system ? builtins.currentSystem }:

let
  rust-semaphore = pkgs.callPackage ./semaphore {};
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

  croniter = self.buildPythonPackage rec {
    pname = "croniter";
    version = "0.3.28";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1d0h2a6izkh2yijc501gsvhsvjlsfrbzm2skcb9q268bkdmdy6n3";
    };

    propagatedBuildInputs = [ self.python-dateutil ];
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

  django-sudo = self.buildPythonPackage rec {
    pname = "django-sudo";
    version = "3.0.0";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1wnp57jq25xxpvvni1kr8k0ym3fbpvmq3iq2l0wy9mbjv9q9dr5i";
    };
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

  google_cloud_pubsub = super.google_cloud_pubsub.overrideAttrs ( oldAttrs: rec {
    pname = "google-cloud-pubsub";
    version = "0.35.4";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "11jc4i2hbjx93qrmv7f8lyh54qafg6dg23g3k9w9jgxl5mvcwv6k";
    };
  });

  google_cloud_storage = super.google_cloud_storage.overrideAttrs ( oldAttrs: rec {
    pname = "google-cloud-storage";
    version = "1.13.3";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1fdi8s0afjw2cdbvv9wdpw3hdbslw8x1y7p72p8ysg545zs4zay8";
    };
  });

  loremipsum = self.buildPythonPackage rec {
    pname = "loremipsum";
    version = "1.0.5";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1x9sabp50zyi2j8dkpxgdkcnj5wrbd4w1v15zsnjpxf30n9wcjdq";
    };

    doCheck = false;
  };

  mmh3 = self.buildPythonPackage rec {
    pname = "mmh3";
    version = "2.3.1";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0a795lk2gqj5ar0diwpd0gsgycv83pwlr0a91fki2ch9giaw7bgc";
    };
  };

  PyJWT = self.buildPythonPackage rec {
    pname = "PyJWT";
    version = "1.5.0";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0jy5sxaajm0l00c80xx6nk4mdlsnjb8269lvkll4rw0kimr2n67x";
    };

    doCheck = false;
  };

  parsimonious = super.parsimonious.overrideAttrs ( oldAttrs: rec {
    pname = "parsimonious";
    version = "0.8.0";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0sq81p00vsilvwyqpzp66vwbygp791bmyfii4hzp0mvf5bbnj25f";
    };
  });

  percy = self.buildPythonPackage rec {
    pname = "percy";
    version = "1.1.2";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1ra7wanlkchpxhjzhx457c30db68x63qjmwizjg0phlc5h527m1k";
    };

    propagatedBuildInputs = [ self.requests self.requests-mock ];
    doCheck = false;
  };

  petname = self.buildPythonPackage rec {
    pname = "petname";
    version = "2.6";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0k4y9jrxb68wgb37hid1xmch2bhhgk3bf6qdcirs6mi3fzpk274q";
    };
  };

  phonenumberslite = self.buildPythonPackage rec {
    pname = "phonenumberslite";
    version = "7.7.5";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "08pn0awqka9byhf42p27kbycy8b0iczcpahh1cyaw82ldzzjk0j9";
    };

    doCheck = false;
  };

  progressbar2 = self.buildPythonPackage rec {
    pname = "progressbar2";
    version = "3.10.1";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0s9ixxgvjs66d1hm57hywb5gxqr4clq7mwq7iiln878wwjrnzx0b";
    };

    propagatedBuildInputs = [ self.pytest-runner self.python-utils ];

    doCheck = false;
  };

  pytest-runner = self.buildPythonPackage rec {
    pname = "pytest-runner";
    version = "2.8";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0p0dd3878sjnk59sk17jl6n0j9is9160mi33smgzhld5vbnlvi0y";
    };

    propagatedBuildInputs = [ self.setuptools_scm ];

    doCheck = false;
  };

  requests-oauthlib = self.buildPythonPackage rec {
    pname = "requests-oauthlib";
    version = "0.3.3";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1s87y2qgwm9k9d0pqqqw9gq330wb2j197p359hm0vxgfwd6pnm9p";
    };

    propagatedBuildInputs = [ self.oauthlib self.requests ];

    doCheck = false;
  };

  setproctitle = super.setproctitle;

  # sentry-sdk = self.buildPythonPackage rec {
  #   pname = "sentry-sdk";
  #   version = "0.13.5";
  #   src = self.fetchPypi {
  #     inherit pname version;
  #     sha256 = "10pyv3ba9vlh593lqzwyypivgnmwy332cqzi52kk90a87ri1kff6";
  #   };
  # };

  sqlparse = super.sqlparse;

  qrcode = self.buildPythonPackage rec {
    pname = "qrcode";
    version = "5.2.2";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "06fyqfnwxk8zxlk5rppks73c2s1l0y8q39a6jx840ww0q6hjhrnr";
    };

    propagatedBuildInputs = [ self.colorama self.six ];

    doCheck = false;
  };

  querystring_parser = self.buildPythonPackage rec {
    pname = "querystring_parser";
    version = "1.2.3";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1sladp7yikiz6vbl6jk5wlpsjahmz0vzmmncrs57m4kvqx3vacac";
    };

    propagatedBuildInputs = [ self.requests ];
  };

  ua-parser = super.ua-parser.overrideAttrs ( oldAttrs: rec {
    pname = "ua-parser";
    version = "0.6.1";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1ygkvwphzf22yf7izwn5w930a4qimkziphmaw97vjxn8jghf8fbs";
    };
  });

  semaphore = self.callPackage ./semaphore { };
}
