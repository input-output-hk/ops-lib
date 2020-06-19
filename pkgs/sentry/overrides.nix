{ fetchpatch
, fetchFromGitHub
, xmlsec
, libtool
, lib
, zlib
, libxml2
, libxslt
, postgresql
}:

self: super:

{
  python3-saml =
    let
      fix2020Patch = fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/onelogin/python3-saml/pull/140.patch";
        sha256 = "0pm40kszv5qcnkw3ksz6c68zkqibakaxdggkxfadiasw9ys91nl6";
      };
      fixCertValue = fetchpatch {
        url = "https://github.com/onelogin/python3-saml/commit/771072e2ae1380acde4ec6af2d7b46b96dccfd2d.patch";
        sha256 = "0yplwcpb5ksxgbfnmmxssj4c9ak1g1p6hfj8nfh2ybrmbk38n2f8";
      };
    in
      self.buildPythonPackage rec {
      pname = "python3-saml";
      version = "1.4.0";

      # Fetch from GitHub because PyPi doesn't have tests available in src
      src = fetchFromGitHub {
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

      LD_LIBRARY_PATH = "${xmlsec}/lib";

      doCheck = false;
    };

  xmlsec = self.buildPythonPackage rec {
    pname = "xmlsec";
    version = "1.3.8";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1ki5jiws8r9sbdbbn5cw058m57rhx42g91rrsa2bblqwngi3z546";
    };

    buildInputs = [ libtool.lib zlib xmlsec.dev xmlsec ];
    propagatedBuildInputs = [ self.lxml self.pkgconfig self.pathlib2 self.setuptools_scm self.toml xmlsec.dev xmlsec ];

    checkInputs = [ self.pytest xmlsec.dev xmlsec self.hypothesis ];
    postPatch = ''
      patch --strip=1 < ${./xmlsec/lxml-workaround.patch}
      patch --strip=1 < ${./xmlsec/no-black-format.patch}
    '';

    LD_LIBRARY_PATH = "${xmlsec}/lib";
    PKG_CONFIG_PATH = "${xmlsec.dev}/lib/pkgconfig:${libxml2.dev}/lib/pkgconfig:${libxslt.dev}/lib/pkgconfig:$PKG_CONFIG_PATH";
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

  djangorestframework = self.buildPythonPackage rec {
    pname = "djangorestframework";
    version = "3.4.7";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0ivyc4p0g8sir5j5z59v7jcj1xnml8qnr0z3rfh15q3dk88qix9l";
    };

    # Test settings are missing
    doCheck = false;

    propagatedBuildInputs = [ self.django ];

    meta = with lib; {
      description = "Web APIs for Django, made easy";
      homepage = "https://www.django-rest-framework.org/";
      maintainers = with maintainers; [ desiderius ];
      license = licenses.bsd2;
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

  google_auth = with self; buildPythonPackage rec {
    pname = "google-auth";
    version = "1.6.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0f7c6a64927d34c1a474da92cfc59e552a5d3b940d3266606c6a28b72888b9e4";
    };
    patches = [
      (fetchpatch {
        name = "use-new-pytest-api-to-keep-building-with-pytest5.patch";
        url = "https://github.com/googleapis/google-auth-library-python/commit/b482417a04dbbc207fcd6baa7a67e16b1a9ffc77.patch";
        sha256 = "07jpa7pa6sffbcwlsg5fgcv2vvngil5qpmv6fhjqp7fnvx0674s0";
      })
    ];

    checkInputs = [ pytest mock oauth2client flask requests urllib3 pytest-localserver ];
    propagatedBuildInputs = [ six pyasn1-modules cachetools rsa ];

    # The removed test tests the working together of google_auth and google's https://pypi.python.org/pypi/oauth2client
    # but the latter is deprecated. Since it is not currently part of the nixpkgs collection and deprecated it will
    # probably never be. We just remove the test to make the tests work again.
    postPatch = ''rm tests/test__oauth2client.py'';

    checkPhase = ''
      py.test
    '';

    meta = with lib; {
      description = "This library simplifies using Google’s various server-to-server authentication mechanisms to access Google APIs.";
      homepage = "https://google-auth.readthedocs.io/en/latest/";
      license = licenses.asl20;
      maintainers = with maintainers; [ vanschelven ];
    };
  };

  google_api_core = self.buildPythonPackage rec {
    pname = "google-api-core";
    version = "1.14.3";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1ajppa7vyawxjpairjq18rylmkvpg3kvwig7l0l47azmjx5xr2nz";
    };

    propagatedBuildInputs = with self; [
      googleapis_common_protos protobuf
      google_auth requests grpcio
    ] ++ lib.optional (pythonOlder "3.2") futures;

    checkInputs = with self; [ mock pytest ];

    checkPhase = ''
      py.test
    '';
    doCheck = false;

    meta = with lib; {
      description = "This library is not meant to stand-alone. Instead it defines common helpers used by all Google API clients.";
      homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
      license = licenses.asl20;
      maintainers = with maintainers; [ vanschelven ];
    };
  };

  google_cloud_core = with self; buildPythonPackage rec {
    pname = "google-cloud-core";
    version = "0.29.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "d85b1aaaf3bad9415ad1d8ee5eadce96d7007a82f13ce0a0629a003a11e83f29";
    };

    propagatedBuildInputs = [ google_api_core grpcio ];
    checkInputs = [ pytest mock ];

    checkPhase = ''
      py.test
    '';
    doCheck = false;

    meta = with lib; {
      description = "API Client library for Google Cloud: Core Helpers";
      homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
      license = licenses.asl20;
      maintainers = with maintainers; [ vanschelven ];
    };
  };

  grpc_google_iam_v1 = with self; buildPythonPackage rec {
    pname = "grpc-google-iam-v1";
    version = "0.11.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "5009e831dcec22f3ff00e89405249d6a838d1449a46ac8224907aa5b0e0b1aec";
    };

    propagatedBuildInputs = [ grpcio googleapis_common_protos ];

    meta = with lib; {
      description = "GRPC library for the google-iam-v1 service";
      homepage = https://github.com/googleapis/googleapis;
      license = licenses.asl20;
      maintainers = [ maintainers.costrouc ];
    };
  };

  google_cloud_bigtable = with self; buildPythonPackage rec {
    pname = "google-cloud-bigtable";
    version = "0.32.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "40d1fc8009c228f70bd0e2176e73a3f101051ad73889b3d25a5df672c029a8bd";
    };

    checkInputs = [ pytest mock ];
    propagatedBuildInputs = [ grpc_google_iam_v1 google_api_core google_cloud_core ];

    checkPhase = ''
      pytest tests/unit
    '';
    doCheck = false;

    meta = with lib; {
      description = "Google Cloud Bigtable API client library";
      homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
      license = licenses.asl20;
      maintainers = [ maintainers.costrouc ];
    };
  };

  google_cloud_pubsub = with self; buildPythonPackage rec {
    pname = "google-cloud-pubsub";
    version = "0.35.4";
    src = fetchPypi {
      inherit pname version;
      sha256 = "11jc4i2hbjx93qrmv7f8lyh54qafg6dg23g3k9w9jgxl5mvcwv6k";
    };

    checkInputs = [ pytest mock ];
    propagatedBuildInputs = [ enum34 grpc_google_iam_v1 google_api_core ];

    checkPhase = ''
      pytest tests/unit
    '';
    doCheck = false;

    meta = with lib; {
      description = "Google Cloud Pub/Sub API client library";
      homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
      license = licenses.asl20;
      maintainers = [ maintainers.costrouc ];
    };
  };

  google_resumable_media = with self; buildPythonPackage rec {
    pname = "google-resumable-media";
    version = "0.3.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "3e38923493ca0d7de0ad91c31acfefc393c78586db89364e91cb4f11990e51ba";
    };

    checkInputs = [ pytest mock ];
    propagatedBuildInputs = [ six requests ];

    checkPhase = ''
      py.test tests/unit
    '';

    meta = with lib; {
      description = "Utilities for Google Media Downloads and Resumable Uploads";
      homepage = https://github.com/GoogleCloudPlatform/google-resumable-media-python;
      license = licenses.asl20;
      maintainers = [ maintainers.costrouc ];
    };
  };

  google_cloud_storage = with self; buildPythonPackage rec {
    pname = "google-cloud-storage";
    version = "1.13.3";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1fdi8s0afjw2cdbvv9wdpw3hdbslw8x1y7p72p8ysg545zs4zay8";
    };

    checkInputs = [ pytest mock ];
    propagatedBuildInputs = [ google_resumable_media google_api_core google_cloud_core ];

    checkPhase = ''
     pytest tests/unit
    '';

    doCheck = false;

    meta = with lib; {
      description = "Google Cloud Storage API client library";
      homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
      license = licenses.asl20;
      maintainers = [ maintainers.costrouc ];
    };
  };

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

  maxmindb = with self; buildPythonPackage rec {
    version = "1.4.1";
    pname = "maxminddb";

    src = fetchPypi {
      inherit pname version;
      sha256 = "04mpilsj76m29id5xfi8mmasdmh27ldn7r0dmh2rj6a8v2y5256z";
    };

    propagatedBuildInputs = [ ipaddress ];

    checkInputs = [ nose mock ];

    meta = with lib; {
      description = "Reader for the MaxMind DB format";
      homepage = "https://www.maxmind.com/en/home";
      license = licenses.apsl20;
      maintainers = with maintainers; [ ];
    };
  };

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

  mock = with self; buildPythonPackage rec {
    pname = "mock";
    version = "2.0.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1flbpksir5sqrvq2z0dp8sl4bzbadg21sj4d42w3klpdfvgvcn5i";
    };

    buildInputs = [ unittest2 ];
    propagatedBuildInputs = [ funcsigs six pbr ];

    # On PyPy for Python 2.7 in particular, Mock's tests have a known failure.
    # Mock upstream has a decoration to disable the failing test and make
    # everything pass, but it is not yet released. The commit:
    # https://github.com/testing-cabal/mock/commit/73bfd51b7185#diff-354f30a63fb0907d4ad57269548329e3L12
    doCheck = !(python.isPyPy && python.isPy27);

    checkPhase = ''
      ${python.interpreter} -m unittest discover
    '';

    meta = with lib; {
      description = "Mock objects for Python";
      homepage = http://python-mock.sourceforge.net/;
      license = licenses.bsd2;
    };
  };

  testresources = with self; buildPythonPackage rec {
    pname = "testresources";
    version = "2.0.1";

    doCheck = false;

    src = fetchPypi {
      inherit pname version;
      sha256 = "ee9d1982154a1e212d4e4bac6b610800bfb558e4fb853572a827bc14a96e4417";
    };

    buildInputs = [ pbr ];

    checkInputs = [ fixtures testtools ];

    checkPhase = ''
      ${python.interpreter} -m testtools.run discover
    '';

    meta = with lib; {
      description = "Pyunit extension for managing expensive test resources";
      homepage = https://launchpad.net/testresources;
      license = licenses.bsd2;
    };
  };

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

    nativeBuildInputs = [ postgresql ];

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

  msgpack = with self; buildPythonPackage rec {
    pname = "msgpack";
    version = "0.6.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "4008c72f5ef2b7936447dcb83db41d97e9791c83221be13d5e19db0796df1972";
    };

    checkPhase = ''
      py.test
    '';

    checkInputs = [ pytest ];

    meta = {
      homepage = https://github.com/msgpack/msgpack-python;
      description = "MessagePack serializer implementation for Python";
      license = lib.licenses.asl20;
      # maintainers =  ?? ;
    };
  };

  unidiff = super.unidiff;

  boto = super.boto.overrideAttrs (oldAttrs: {
    doCheck = false;
  });

  django = self.buildPythonPackage rec {
    pname = "Django";
    version = "1.9";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0rkwdxh63y7pwx9larl2g7m1z206675dzx7ipd44p3bpm0clpzh5";
    };

    propagatedBuildInputs = [ self.pytz ];

    # too complicated to setup
    doCheck = false;

    meta = with lib; {
      description = "A high-level Python Web framework";
      homepage = "https://www.djangoproject.com/";
      license = licenses.bsd3;
    };
  };

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

  beautifulsoup4 = with self; buildPythonPackage rec {
    pname = "beautifulsoup4";
    version = "4.7.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "945065979fb8529dd2f37dbb58f00b661bdbcbebf954f93b32fdf5263ef35348";
    };

    checkInputs = [ pytest ];
    checkPhase = ''
      py.test $out/${python.sitePackages}/bs4/tests
    '';

    propagatedBuildInputs = [ soupsieve ];

    meta = with lib; {
      homepage = http://crummy.com/software/BeautifulSoup/bs4/;
      description = "HTML and XML parser";
      license = licenses.mit;
      maintainers = with maintainers; [ domenkozar ];
    };
  };

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

  sqlparse = with self; buildPythonPackage rec {
    pname = "sqlparse";
    version = "0.2.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "ce028444cfab83be538752a2ffdb56bc417b7784ff35bb9a3062413717807dec";
    };

    checkInputs = [ pytest ];
    checkPhase = ''
      py.test
    '';

    # Package supports 3.x, but tests are clearly 2.x only.
    doCheck = !isPy3k;

    meta = with lib; {
      description = "Non-validating SQL parser for Python";
      longDescription = ''
        Provides support for parsing, splitting and formatting SQL statements.
      '';
      homepage = https://github.com/andialbrecht/sqlparse;
      license = licenses.bsd3;
    };
  };

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

  billiard = self.buildPythonPackage rec {
    pname = "billiard";
    version = "3.3.0.20";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1k18d4gr6ikciss2wm0c4v2paphi539xprl1cc819bn3n5k993v8";
    };

    propagatedBuildInputs = [ self.nose-cover3 ];

    checkInputs = with self; [ pytest case psutil ];
    checkPhase = ''
      pytest
    '';

    doCheck = false;

    meta = with lib; {
      homepage = "https://github.com/celery/billiard";
      description = "Python multiprocessing fork with improvements and bugfixes";
      license = licenses.bsd3;
    };
  };

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

  datadog = with self; buildPythonPackage rec {
    pname = "datadog";
    version = "0.29.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0p47hy1p2hf233blalyz0yr6nf13iwk9ndkqdk428dmf8b8m2plr";
    };

    postPatch = ''
      find . -name '*.pyc' -exec rm {} \;
    '';

    propagatedBuildInputs = [ decorator requests simplejson ];

    checkInputs = [ nose mock ];

    meta = with lib; {
      description = "The Datadog Python library";
      license = licenses.bsd3;
      homepage = https://github.com/DataDog/datadogpy;
    };
  };

  jsonschema = self.buildPythonPackage rec {
    pname = "jsonschema";
    version = "2.6.0";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "00kf3zmpp9ya4sydffpifn0j0mzm342a2vzh82p6r0vh10cg7xbg";
    };

    checkInputs = with self; [ nose mock vcversioner ];
    propagatedBuildInputs = with self; [ functools32 ];

    postPatch = ''
      substituteInPlace jsonschema/tests/test_jsonschema_test_suite.py \
        --replace "python" "${self.python.pythonForBuild.interpreter}"
    '';

    checkPhase = ''
      nosetests
    '';

    meta = with lib; {
      homepage = https://github.com/Julian/jsonschema;
      description = "An implementation of JSON Schema validation for Python";
      license = licenses.mit;
      maintainers = with maintainers; [ domenkozar ];
    };
  };

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

  defusedxml = self.buildPythonPackage rec {
    pname = "defusedxml";
    version = "0.5.0";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1x54n0h8hl92vvwyymx883fbqpqjwn2mc8fb383bcg3z9zwz5mr4";
    };
  };

  lxml = with self; buildPythonPackage rec {
    pname = "lxml";
    version = "4.3.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "4a03dd682f8e35a10234904e0b9508d705ff98cf962c5851ed052e9340df3d90";
    };

    nativeBuildInputs = [ libxml2.dev libxslt.dev ];
    buildInputs = [ libxml2 libxslt ];

    meta = with lib; {
      description = "Pythonic binding for the libxml2 and libxslt libraries";
      homepage = https://lxml.de;
      license = licenses.bsd3;
      maintainers = with maintainers; [ sjourdois ];
    };
  };
}
