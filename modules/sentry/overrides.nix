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

  google_api_core = super.google_api_core.overrideAttrs ( oldAttrs: rec {
    pname = "google-api-core";
    version = "1.14.3";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1ajppa7vyawxjpairjq18rylmkvpg3kvwig7l0l47azmjx5xr2nz";
    };
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

  oauth2 = super.oauth2;

  mistune = super.mistune;

  memcached = self.buildPythonPackage rec {
    pname = "memcached";
    version = "1.53";

    src = self.fetchPypi {
      pname = "python-memcached";
      inherit version;
      sha256 = "0s48xy0mccdl1lqzjnh2rk5cqmkbwsm66ywa2sildfwpv5qi7xxw";
    };
  };

  redis-py-cluster = self.buildPythonPackage rec {
    pname = "redis-py-cluster";
    version = "1.3.4";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0n7k4nqdryz1x34f5axbhj7xl6s1b6hlav02491nzy047bgdv29i";
    };

    propagatedBuildInputs = [ self.redis ];
  };

  click = self.buildPythonPackage rec {
    pname = "click";
    version = "5.1";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0njsm0wn31l21bi118g5825ma5sa3rwn7v2x4wjd7yiiahkri337";
    };
  };

  cached-property = super.cached-property;

  pillow = super.pillow.overrideAttrs (oldAttrs: rec {
    pname = "Pillow";
    version = "6.2.1";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1c8wkzc58f5wdh006jvmwdk3wxld1xgagcbdvj7iv17qi0m9fkmz";
    };
  });

  maxmindb = super.maxminddb;

  six = self.buildPythonPackage rec {
    pname = "six";
    version = "1.10.0";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0snmb8xffb3vsma0z67i0h0w2g2dy0p3gsgh9gi4i0kgc5l8spqh";
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

  phabricator = self.buildPythonPackage rec {
    pname = "phabricator";
    version = "0.6.0";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1bw88fww4k3lh7nf7ic95xi0qnxnid9sm0961qyky4lr640ldgc8";
    };

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

  psycopg2-binary = self.buildPythonPackage rec {
    pname = "psycopg2-binary";
    version = "2.7.4";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1myrbdbjzm2gd3dfscri6irqv9mqjqfh9hgkbvm72yh34gw8hkyy";
    };

    nativeBuildInputs = [ pkgs.postgresql ];

    doCheck = false;
  };

  redis = self.buildPythonPackage rec {
    pname = "redis";
    version = "2.10.3";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1701qjwn4n05q90fdg4bsg96s27xf5s4hsb4gxhv3xk052q3gyx4";
    };

    doCheck = false;
  };

  toronado = self.buildPythonPackage rec {
    pname = "toronado";
    version = "0.0.11";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1a5hvn9fhhkbkdsqr9fw4jhvd7vhhrd4a06nf89zlsf92fddr1br";
    };

    propagatedBuildInputs = [ self.lxml self.cssselect self.cssutils ];

    doCheck = false;
  };

  django-picklefield = self.buildPythonPackage rec {
    pname = "django-picklefield";
    version = "0.3.0";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1w52p9lzgqj7z1s0v0hl8y56aj2l9szyndqw1dznlhpckcdj7nyi";
    };

    propagatedBuildInputs = [ self.six ];
  };

  msgpack = super.msgpack;

  unidiff = super.unidiff;

  botocore = self.buildPythonPackage rec {
    pname = "botocore";
    version = "1.5.70";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1wngbi4n9gchdrz65g5n9ny3b3j2m2gxbl5ms601d9sgc5aixvma";
    };

    propagatedBuildInputs = [ self.python-dateutil self.jmespath self.docutils ];

    doCheck = false;
  };

  beautifulsoup4 = super.beautifulsoup4;

  setproctitle = super.setproctitle;

  sentry-sdk = self.buildPythonPackage rec {
    pname = "sentry-sdk";
    version = "0.13.5";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "10pyv3ba9vlh593lqzwyypivgnmwy332cqzi52kk90a87ri1kff6";
    };

    propagatedBuildInputs = [ self.urllib3 ];
  };

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
