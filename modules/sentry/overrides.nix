{ pkgs, system ? builtins.currentSystem }:

self: super:

{
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
      self.buildPythonPackage rec {
      pname = "python3-saml";
      version = "1.4.0";
  
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
  
      propagatedBuildInputs = [ self.defusedxml self.xmlsec self.isodate ];
  
      checkInputs = [ self.pytest self.coverage self.freezegun self.pylint self.flake8 self.coveralls ];
  
      LD_LIBRARY_PATH = "${pkgs.xmlsec}/lib";
    };

  xmlsec = self.buildPythonPackage rec {
    pname = "xmlsec";
    version = "1.3.8";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1ki5jiws8r9sbdbbn5cw058m57rhx42g91rrsa2bblqwngi3z546";
    };

    buildInputs = [ pkgs.libtool.lib pkgs.zlib pkgs.xmlsec.dev pkgs.xmlsec ];
    propagatedBuildInputs = [ self.lxml self.pkgconfig self.pathlib2 self.setuptools_scm self.toml pkgs.xmlsec.dev pkgs.xmlsec ];

    checkInputs = [ self.pytest pkgs.xmlsec.dev pkgs.xmlsec self.hypothesis ];
    postPatch = ''
      patch --strip=1 < ${./xmlsec/lxml-workaround.patch}
      patch --strip=1 < ${./xmlsec/no-black-format.patch}
    '';

    LD_LIBRARY_PATH = "${pkgs.xmlsec}/lib";
    PKG_CONFIG_PATH = "${pkgs.xmlsec.dev}/lib/pkgconfig:${pkgs.libxml2.dev}/lib/pkgconfig:${pkgs.libxslt.dev}/lib/pkgconfig:$PKG_CONFIG_PATH";
  };

  amqp = self.buildPythonPackage rec {
    pname = "amqp";
    version = "1.4.9";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "06n6q0kxhjnbfz3vn8x9yz09lwmn1xi9d6wxp31h5jbks0b4vsid";
    };

    checkInputs = [ self.mock self.coverage self.nose-cover3 self.unittest2 ];

    doCheck = false;
  };

  croniter = self.buildPythonPackage rec {
    pname = "croniter";
    version = "0.3.28";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1d0h2a6izkh2yijc501gsvhsvjlsfrbzm2skcb9q268bkdmdy6n3";
    };

    propagatedBuildInputs = [ self.python-dateutil ];

    doCheck = false;
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

    doCheck = false;
  };

  djangorestframework = super.djangorestframework.overrideAttrs ( oldAttrs: rec {
    version = "3.4.7";

    src = self.fetchPypi {
      inherit version;
      inherit (oldAttrs) pname;
      sha256 = "0ivyc4p0g8sir5j5z59v7jcj1xnml8qnr0z3rfh15q3dk88qix9l";
    };
  });

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

    doCheck = false;
  };

  googleapis_common_protos = super.googleapis_common_protos.overrideAttrs ( oldAttrs: rec {
    pname = "googleapis-common-protos";
    version = "1.6.0";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1im0ad5vdyjagy1hwp5xlw67l35i3griayvfgi46p5vbwgaqw6z6";
    };
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ self.protobuf ];

    doCheck = false;
  });

  google_api_core = super.google_api_core.overrideAttrs ( oldAttrs: rec {
    pname = "google-api-core";
    version = "1.14.3";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1ajppa7vyawxjpairjq18rylmkvpg3kvwig7l0l47azmjx5xr2nz";
    };

    doCheck = false;
  });

  google_cloud_bigtable = super.google_cloud_bigtable.overrideAttrs ( oldAttrs: rec {
    pname = "google-cloud-bigtable";
    version = "0.32.2";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1gd857075xjxbb9b729qswd0a0gildrnw5z2s05zfa62160grla0";
    };

    doCheck = false;
  });

  google_cloud_pubsub = super.google_cloud_pubsub.overrideAttrs ( oldAttrs: rec {
    pname = "google-cloud-pubsub";
    version = "0.35.4";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "11jc4i2hbjx93qrmv7f8lyh54qafg6dg23g3k9w9jgxl5mvcwv6k";
    };

    doCheck = false;
  });

  google_cloud_storage = super.google_cloud_storage.overrideAttrs ( oldAttrs: rec {
    pname = "google-cloud-storage";
    version = "1.13.3";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1fdi8s0afjw2cdbvv9wdpw3hdbslw8x1y7p72p8ysg545zs4zay8";
    };

    doCheck = false;
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

    doCheck = false;
  };

  redis-py-cluster = self.buildPythonPackage rec {
    pname = "redis-py-cluster";
    version = "1.3.4";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0n7k4nqdryz1x34f5axbhj7xl6s1b6hlav02491nzy047bgdv29i";
    };

    propagatedBuildInputs = [ self.redis ];

    doCheck = false;
  };

  click = self.buildPythonPackage rec {
    pname = "click";
    version = "5.1";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0njsm0wn31l21bi118g5825ma5sa3rwn7v2x4wjd7yiiahkri337";
    };

    doCheck = false;
  };

  cached-property = super.cached-property;

  pillow = super.pillow.overrideAttrs (oldAttrs: rec {
    pname = "Pillow";
    version = "6.2.1";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1c8wkzc58f5wdh006jvmwdk3wxld1xgagcbdvj7iv17qi0m9fkmz";
    };

    doCheck = false;
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

    doCheck = false;
  };

  pyjwt = self.buildPythonPackage rec {
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

    doCheck = false;
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

  mock = super.mock;

  petname = self.buildPythonPackage rec {
    pname = "petname";
    version = "2.6";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0k4y9jrxb68wgb37hid1xmch2bhhgk3bf6qdcirs6mi3fzpk274q";
    };

    doCheck = false;
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

    doCheck = false;
  };

  pytest = super.pytest.overrideAttrs (oldAttrs: rec {
    doCheck = false;
  });

  symbolic = self.callPackage ./symbolic { };

  setuptools_cython = self.buildPythonPackage rec {
    pname = "setuptools_cython";
    version = "0.2.1";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0kva3dj4s5jbqm2n6md978nbgz8yp31vpdzq7p9jxyk68nalzn18";
    };

    propagatedBuildInputs = [ self.cython ];
  };

  setuptools_scm = super.setuptools_scm.overrideAttrs (oldAttrs: rec {
    version = "3.4.0";

    src = self.fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "1dwzhn3qgs9nn0cy68pfglgx202zf6ka7kkg34np2lmiwi0a6vcb";
    };
  });

  hiredis = self.buildPythonPackage rec {
    pname = "hiredis";
    version = "0.1.6";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0dba7fm5s8wf1mnsx6r0ffr786g50jgmh7llw4pign1i08m2dpxn";
    };
  };

  msgpack = super.msgpack;

  unidiff = super.unidiff;

  boto = super.boto.overrideAttrs (oldAttrs: {
    doCheck = false;
  });

  django = super.django.overrideAttrs (oldAttrs: rec {
    version = "1.9";

    src = self.fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "0rkwdxh63y7pwx9larl2g7m1z206675dzx7ipd44p3bpm0clpzh5";
    };
  });

  functools32 = super.functools32;


  simplejson = super.simplejson.overrideAttrs (oldAttrs: rec {
    version = "3.2.0";

    src = self.fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "15gns6l47dh4gi2pqyrpk43vxsj84n8sp4mwjfgm31pg2297klm6";
    };
  });

  boto3 = super.boto3.overrideAttrs (oldAttrs: rec {
    version = "1.4.5";

    src = self.fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "07c3364s071p3w6vgz4c7s0b56dqhi2vpbxbx4sjps4jyvq0smvd";
    };
  });

  s3transfer = super.s3transfer.overrideAttrs (oldAttrs: rec {
    version = "0.1.10";

    src = self.fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "1h8g9bknvxflxkpbnxyfxmk8pvgykbbk9ljdvhqh6z4vjc2926ms";
    };
  });

  botocore = self.buildPythonPackage rec {
    pname = "botocore";
    version = "1.5.70";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1wngbi4n9gchdrz65g5n9ny3b3j2m2gxbl5ms601d9sgc5aixvma";
    };

    propagatedBuildInputs = [ self.python-dateutil self.jmespath self.docutils self.urllib3 ];

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

    doCheck = false;
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

    doCheck = false;
  };

  rb = self.buildPythonPackage rec {
    pname = "rb";
    version = "1.7";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1sjqia19dap042idbdibyqa951gck64jqgbxp78ammgxcnnaq499";
    };

    propagatedBuildInputs = [ self.redis ];

    doCheck = false;
  };

  celery = self.buildPythonPackage rec {
    pname = "celery";
    version = "3.1.18";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1bry1qzb4gw0ni40w1pyzxl2d0rqbf688sdi13a5gz66f10gj909";
    };

    propagatedBuildInputs = [ self.kombu self.billiard self.pytz self.anyjson self.amqp self.eventlet ];

    checkInputs = [ self.case self.pytest self.mock self.unittest2 self.coverage self.nose-cover3 self.nose-exclude ];

    doCheck = false;
  };

  PyYAML = self.buildPythonPackage rec {
    pname = "PyYAML";
    version = "3.11";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1s26125vfnskng58ym37xhwv8v0mm95b2cwbjfag8prfhy596v63";
    };

    doCheck = false;
  };

  statsd = super.statsd.overrideAttrs ( oldAttrs: rec {
    pname = "statsd";
    version = "3.1";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1vi8xx8hrgyhgcw3d3yc7bh4vfc48swlm0xwfp1994xf6gmmzbpv";
    };
  });

  selenium = super.selenium;

  urllib3 = super.urllib3.overrideAttrs ( oldAttrs: rec {
    pname = "urllib3";
    version = "1.24.2";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1hwscrsw77vbkzdbw0db74zzf1135521wwccngnlz73hvxrp494s";
    };

    doCheck = false;
  });

  requests = super.requests.overrideAttrs ( oldAttrs: rec {
    pname = "requests";
    version = "2.20.0";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "033p8ax4qs81g0c95ngincm52q84g1xnlazk4vjzdjhpxfmgvp4r";
    };

    doCheck = false;
  });

  confluent-kafka = super.confluent-kafka.overrideAttrs ( oldAttrs: rec {
    pname = "confluent-kafka";
    version = "0.11.5";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "17rvlrid7l4abmjry2ayn9r9wjjnx3iy8rgy5i7xgzsyzdxq1ddz";
    };

    doCheck = false;
  });

  strict-rfc3339 = super.strict-rfc3339;

  idna = super.idna.overrideAttrs ( oldAttrs: rec {
    pname = "idna";
    version = "2.5";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1ara12a7k2zc69msa0arrvw00gn61a6i6by01xb3lkkc0h4cxd9w";
    };

    doCheck = false;
  });

  ua-parser = super.ua-parser.overrideAttrs ( oldAttrs: rec {
    pname = "ua-parser";
    version = "0.6.1";
    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1ygkvwphzf22yf7izwn5w930a4qimkziphmaw97vjxn8jghf8fbs";
    };

    doCheck = false;
  });

  semaphore = self.callPackage ./semaphore { };

  billiard = super.billiard.overrideAttrs (oldAttrs: rec {
    pname = "billiard";
    version = "3.3.0.20";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1k18d4gr6ikciss2wm0c4v2paphi539xprl1cc819bn3n5k993v8";
    };

    propagatedBuildInputs = [ self.nose-cover3 ];

    doCheck = false;
  });

  structlog = self.buildPythonPackage rec {
    pname = "structlog";
    version = "16.1.0";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "00dywyg3bqlkrmbrfrql21hpjjjkc4zjd6xxjyxyd15brfnzlkdl";
    };

    propagatedBuildInputs = [ self.six ];
    doCheck = false;
  };

  datadog = super.datadog;
  jsonschema = super.jsonschema;

  python-u2flib-server = self.buildPythonPackage rec {
    pname = "python-u2flib-server";
    version = "5.0.0";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "09n2phl1qr6rs35kxx02awkwlhdmgd5xnavwl33sn97y2gdl944v";
    };

    propagatedBuildInputs = [ self.six self.enum34 self.cryptography ];
  };

  milksnake = super.milksnake;

  # uwsgi = self.buildPythonPackage rec {
  #   pname = "uwsgi";
  #   version = "2.0.18";

  #   src = self.fetchPypi {
  #     inherit pname version;
  #     sha256 = "10zmk4npknigmbqcq1wmhd461dk93159px172112vyq0i19sqwj9";
  #   };
  # };

  # uwsgi = (pkgs.uwsgi.override {
  #   plugins = ["python2"];
  # }).overrideAttrs(drv: {
  #   nativeBuildInputs = drv.nativeBuildInputs ++ [ pkgs.breakpointHook ];
  #   installPhase = drv.installPhase + ''
  #     exit 1
  #     mkdir $out/${pkgs.python2.sitePackages}/uwsgi
  #     ln -s $out/lib/uwsgi/python2_plugin.so $out/${pkgs.python2.sitePackages}/uwsgi/uwsgi.so
  #     cat <<EOF > $out/${pkgs.python2.sitePackages}/uwsgi/__init__.py
  #     VERSION = (2, 0, 18)
  #     EOF
  #   '';
  # });
  # uwsgi = pkgs.uwsgi.overrideAttrs(drv: {
  #   plugins = ["python2"];
  #   nativeBuildInputs = drv.nativeBuildInputs ++ [ pkgs.breakpointHook ];
  #   configurePhase = ''
  #     echo "BUILD PHASE"
  #     echo "${drv.buildPhase}"
  #     echo "END BUILD PHASE"
  #   '' + drv.configurePhase;
  #   buildPhase = ''exit 1'' + drv.buildPhase;
  # });
}
