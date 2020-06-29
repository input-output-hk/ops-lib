# generated using pypi2nix tool (version: 2.0.4)
# See more at: https://github.com/nix-community/pypi2nix
#
# COMMAND:
#   pypi2nix -r requirements-base.txt -V python27 -E 'postgresql libxml2 libxslt rdkafka openssl zlib zlib.dev libffi.dev' -s milksnake -s isodate -s jsonschema -s cffi -s defusedxml -s pytest-runner -s progressbar2 -s ua-parser -s isodate -s vcversioner -s pathlib2 -s toml -s scandir
#

{ pkgs ? import <nixpkgs> {},
  overrides ? ({ pkgs, python }: self: super: {})
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python27Full;
  };

  commonBuildInputs = with pkgs; [ postgresql libxml2 libxslt rdkafka openssl zlib zlib.dev libffi.dev ];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreterWithPackages = selectPkgsFn: pythonPackages.buildPythonPackage {
        name = "python27Full-interpreter";
        buildInputs = [ makeWrapper ] ++ (selectPkgsFn pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter} \
              $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "
              (selectPkgsFn pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -x "$prog" ] && [ -f "$prog" ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable} \
              python2
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };

      interpreter = interpreterWithPackages builtins.attrValues;
    in {
      __old = pythonPackages;
      inherit interpreter;
      inherit interpreterWithPackages;
      mkDerivation = args: pythonPackages.buildPythonPackage (args // {
        nativeBuildInputs = (args.nativeBuildInputs or []) ++ args.buildInputs;
      });
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (
          drv.drvAttrs // f drv.drvAttrs // { meta = drv.meta; }
        );
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {
    "amqp" = python.mkDerivation {
      name = "amqp-1.4.9";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/cc/a4/f265c6f9a7eb1dd45d36d9ab775520e07ff575b11ad21156f9866da047b2/amqp-1.4.9.tar.gz";
        sha256 = "2dea4d16d073c902c3b89d9b96620fb6729ac0f7a923bbc777cb4ad827c0c61a";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/celery/py-amqp";
        license = licenses.lgpl2;
        description = "Low-level AMQP client for Python (fork of amqplib)";
      };
    };

    "anyjson" = python.mkDerivation {
      name = "anyjson-0.3.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c3/4d/d4089e1a3dd25b46bebdb55a992b0797cff657b4477bc32ce28038fdecbc/anyjson-0.3.3.tar.gz";
        sha256 = "37812d863c9ad3e35c0734c42e0bf0320ce8c3bed82cd20ad54cb34d158157ba";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://bitbucket.org/runeh/anyjson/";
        license = licenses.bsdOriginal;
        description = "Wraps the best available JSON implementation available in a common interface";
      };
    };

    "backports-functools-lru-cache" = python.mkDerivation {
      name = "backports-functools-lru-cache-1.6.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ad/2e/aa84668861c3de458c5bcbfb9813f0e26434e2232d3e294469e96efac884/backports.functools_lru_cache-1.6.1.tar.gz";
        sha256 = "8fde5f188da2d593bd5bc0be98d9abc46c95bb8a9dde93429570192ee6cc2d4a";
};
      doCheck = commonDoCheck;
      format = "pyproject";
      buildInputs = commonBuildInputs ++ [
        self."setuptools"
        self."setuptools-scm"
        self."wheel"
      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jaraco/backports.functools_lru_cache";
        license = licenses.mit;
        description = "Backport of functools.lru_cache";
      };
    };

    "beautifulsoup4" = python.mkDerivation {
      name = "beautifulsoup4-4.7.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/80/f2/f6aca7f1b209bb9a7ef069d68813b091c8c3620642b568dac4eb0e507748/beautifulsoup4-4.7.1.tar.gz";
        sha256 = "945065979fb8529dd2f37dbb58f00b661bdbcbebf954f93b32fdf5263ef35348";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."soupsieve"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.crummy.com/software/BeautifulSoup/bs4/";
        license = licenses.mit;
        description = "Screen-scraping library";
      };
    };

    "billiard" = python.mkDerivation {
      name = "billiard-3.3.0.23";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/64/a6/d7b6fb7bd0a4680a41f1d4b27061c7b768c673070ba8ac116f865de4e7ca/billiard-3.3.0.23.tar.gz";
        sha256 = "692a2a5a55ee39a42bcb7557930e2541da85df9ea81c6e24827f63b80cd39d0b";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/celery/billiard";
        license = licenses.bsdOriginal;
        description = "Python multiprocessing fork with improvements and bugfixes";
      };
    };

    "boto3" = python.mkDerivation {
      name = "boto3-1.4.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c7/ba/37e3657129590191ab2a8fade26355d56b8811bbac8bf446ef6d6bc6f0c8/boto3-1.4.5.tar.gz";
        sha256 = "6d570df0f692e82b35e9abafbb4584b899b2803e8cfcb70d1f371ca08919831d";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."botocore"
        self."jmespath"
        self."s3transfer"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/boto3";
        license = licenses.asl20;
        description = "The AWS SDK for Python";
      };
    };

    "botocore" = python.mkDerivation {
      name = "botocore-1.5.70";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/1d/83/a935afd5920b372a44a1cc9983661bcfe0ff72fb99d47fef7b242783e588/botocore-1.5.70.tar.gz";
        sha256 = "aaee1e55614fa71680d1b5d0d59fa8428e35bc4db6bc627e6e90bd64495ccff2";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."docutils"
        self."jmespath"
        self."python-dateutil"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/botocore";
        license = licenses.asl20;
        description = "Low-level, data-driven core of boto 3.";
      };
    };

    "cached-property" = python.mkDerivation {
      name = "cached-property-1.5.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/57/8e/0698e10350a57d46b3bcfe8eff1d4181642fd1724073336079cb13c5cf7f/cached-property-1.5.1.tar.gz";
        sha256 = "9217a59f14a5682da7c4b8829deadbfc194ac22e9908ccf7c8820234e80a1504";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pydanny/cached-property";
        license = licenses.bsdOriginal;
        description = "A decorator for caching properties in classes.";
      };
    };

    "cachetools" = python.mkDerivation {
      name = "cachetools-3.1.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ae/37/7fd45996b19200e0cb2027a0b6bef4636951c4ea111bfad36c71287247f6/cachetools-3.1.1.tar.gz";
        sha256 = "8ea2d3ce97850f31e4a08b0e2b5e6c34997d7216a9d2c98e0f3978630d4da69a";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tkem/cachetools";
        license = licenses.mit;
        description = "Extensible memoizing collections and decorators";
      };
    };

    "celery" = python.mkDerivation {
      name = "celery-3.1.18";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/2f/b9/8a5d74bb351c5082465aaddf8772cfe6d4e954da68f3ac0f79bfd48f22df/celery-3.1.18.tar.gz";
        sha256 = "0924f94070c6fc57d408b169848c5b38832668fffe060e48b4803fb23e0e3eaf";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."billiard"
        self."kombu"
        self."pytz"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://celeryproject.org";
        license = licenses.bsdOriginal;
        description = "Distributed Task Queue";
      };
    };

    "certifi" = python.mkDerivation {
      name = "certifi-2020.6.20";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz";
        sha256 = "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://certifiio.readthedocs.io/en/latest/";
        license = licenses.mpl20;
        description = "Python package for providing Mozilla's CA Bundle.";
      };
    };

    "cffi" = python.mkDerivation {
      name = "cffi-1.14.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz";
        sha256 = "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pycparser"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://cffi.readthedocs.org";
        license = licenses.mit;
        description = "Foreign Function Interface for Python calling C code.";
      };
    };

    "chardet" = python.mkDerivation {
      name = "chardet-3.0.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz";
        sha256 = "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/chardet/chardet";
        license = licenses.lgpl2;
        description = "Universal encoding detector for Python 2 and 3";
      };
    };

    "click" = python.mkDerivation {
      name = "click-6.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz";
        sha256 = "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/mitsuhiko/click";
        license = licenses.bsdOriginal;
        description = "A simple wrapper around optparse for powerful command line utilities.";
      };
    };

    "confluent-kafka" = python.mkDerivation {
      name = "confluent-kafka-0.11.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/bf/41/25a4e23a98df212e910aecd445d3b1ea37928ef857749a85365da7108b83/confluent-kafka-0.11.5.tar.gz";
        sha256 = "bfb5807bfb5effd74f2cfe65e4e3e8564a9e72b25e099f655d8ad0d362a63b9f";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."enum34"
        self."futures"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/confluentinc/confluent-kafka-python";
        license = "UNKNOWN";
        description = "Confluent's Apache Kafka client for Python";
      };
    };

    "croniter" = python.mkDerivation {
      name = "croniter-0.3.34";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/67/59/9e30c03c61ea20724bbc2a5e5ec606e3d29f96435ad93a2400ebbeb29f7d/croniter-0.3.34.tar.gz";
        sha256 = "7186b9b464f45cf3d3c83a18bc2344cc101d7b9fd35a05f2878437b14967e964";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."natsort"
        self."python-dateutil"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/kiorky/croniter";
        license = licenses.mit;
        description = "croniter provides iteration for datetime object with cron like format";
      };
    };

    "cryptography" = python.mkDerivation {
      name = "cryptography-2.9.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/56/3b/78c6816918fdf2405d62c98e48589112669f36711e50158a0c15d804c30d/cryptography-2.9.2.tar.gz";
        sha256 = "a0c30272fb4ddda5f5ffc1089d7405b7a71b0b0f51993cb4e5dbb4590b2fc229";
};
      doCheck = commonDoCheck;
      format = "pyproject";
      buildInputs = commonBuildInputs ++ [
        self."cffi"
        self."setuptools"
        self."wheel"
      ];
      propagatedBuildInputs = [
        self."cffi"
        self."enum34"
        self."ipaddress"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pyca/cryptography";
        license = licenses.asl20;
        description = "cryptography is a package which provides cryptographic recipes and primitives to Python developers.";
      };
    };

    "cssselect" = python.mkDerivation {
      name = "cssselect-1.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/70/54/37630f6eb2c214cdee2ae56b7287394c8aa2f3bafb8b4eb8c3791aae7a14/cssselect-1.1.0.tar.gz";
        sha256 = "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/scrapy/cssselect";
        license = licenses.bsdOriginal;
        description = "cssselect parses CSS3 Selectors and translates them to XPath 1.0";
      };
    };

    "cssutils" = python.mkDerivation {
      name = "cssutils-1.0.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5c/0b/c5f29d29c037e97043770b5e7c740b6252993e4b57f029b3cd03c78ddfec/cssutils-1.0.2.tar.gz";
        sha256 = "a2fcf06467553038e98fea9cfe36af2bf14063eb147a70958cfcaa8f5786acaf";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://cthedot.de/cssutils/";
        license = licenses.lgpl2;
        description = "A CSS Cascading Style Sheets library for Python";
      };
    };

    "datadog" = python.mkDerivation {
      name = "datadog-0.30.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/02/72/b52d60c70948b3bde491245e3768637efae8ffa2906d5aab4a6ec1da10e5/datadog-0.30.0.tar.gz";
        sha256 = "07c053e39c6509023d69bc2f3b8e3d5d101b4e75baf2da2b9fc707391c3e773d";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."decorator"
        self."requests"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.datadoghq.com";
        license = licenses.bsdOriginal;
        description = "The Datadog Python library";
      };
    };

    "decorator" = python.mkDerivation {
      name = "decorator-4.4.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz";
        sha256 = "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/micheles/decorator";
        license = licenses.bsdOriginal;
        description = "Decorators for Humans";
      };
    };

    "defusedxml" = python.mkDerivation {
      name = "defusedxml-0.6.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a4/5f/f8aa58ca0cf01cbcee728abc9d88bfeb74e95e6cb4334cfd5bed5673ea77/defusedxml-0.6.0.tar.gz";
        sha256 = "f684034d135af4c6cbb949b8a4d2ed61634515257a67299e5f940fbaa34377f5";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tiran/defusedxml";
        license = licenses.psfl;
        description = "XML bomb protection for Python stdlib modules";
      };
    };

    "django" = python.mkDerivation {
      name = "django-1.11.29";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/68/ab/2278a4a9404fac661be1be9627f11336613149e07fc4df0b6e929cc9f300/Django-1.11.29.tar.gz";
        sha256 = "4200aefb6678019a0acf0005cd14cfce3a5e6b9b90d06145fcdd2e474ad4329c";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pytz"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.djangoproject.com/";
        license = licenses.bsdOriginal;
        description = "A high-level Python Web framework that encourages rapid development and clean, pragmatic design.";
      };
    };

    "django-crispy-forms" = python.mkDerivation {
      name = "django-crispy-forms-1.6.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ef/f3/511b017c2cc3923bc3b317111fa230b0497d12ae3a9ed4c8c2237c07aef1/django-crispy-forms-1.6.1.tar.gz";
        sha256 = "c894f3a44e111ae6c6226c67741d96d120adb942de41dc8b2a991b87de7ff9c0";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/maraujop/django-crispy-forms";
        license = licenses.mit;
        description = "Best way to have Django DRY forms";
      };
    };

    "django-picklefield" = python.mkDerivation {
      name = "django-picklefield-1.0.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e8/69/232d78ef16cad8dd4c2f871b0f44d87bcde36ed6a90597416e903034600b/django-picklefield-1.0.0.tar.gz";
        sha256 = "61e3ba7f6df82d8df9e6be3a8c55ef589eb3bf926c3d25d2b7949b07eae78354";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/gintas/django-picklefield";
        license = licenses.mit;
        description = "Pickled object field for Django";
      };
    };

    "django-sudo" = python.mkDerivation {
      name = "django-sudo-3.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ca/63/9ad066bf7f9c3193fb1d9b8d8d926400acc32ea8d140fb27018bff5587b4/django-sudo-3.1.0.tar.gz";
        sha256 = "671c9b819580d35688f2084e3f2cf60ebc1bfee7cbcf07882160ccf3fbb85a67";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/mattrobenolt/django-sudo";
        license = licenses.bsdOriginal;
        description = "Extra security for your sensitive pages";
      };
    };

    "djangorestframework" = python.mkDerivation {
      name = "djangorestframework-3.9.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ce/1d/877af49d161879bc26585696ca0cab6487c4cb7604263cf5f1c745f5141a/djangorestframework-3.9.4.tar.gz";
        sha256 = "c12869cfd83c33d579b17b3cb28a2ae7322a53c3ce85580c2a2ebe4e3f56c4fb";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.django-rest-framework.org/";
        license = licenses.bsdOriginal;
        description = "Web APIs for Django, made easy.";
      };
    };

    "docutils" = python.mkDerivation {
      name = "docutils-0.16";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz";
        sha256 = "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docutils.sourceforge.net/";
        license = licenses.publicDomain;
        description = "Docutils -- Python Documentation Utilities";
      };
    };

    "email-reply-parser" = python.mkDerivation {
      name = "email-reply-parser-0.2.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/96/1b/a6c9acd8e78e758a7a2f4a30dbcfbf38063a58363b1086d3e5fcdd54fc51/email_reply_parser-0.2.0.tar.gz";
        sha256 = "3fd098e40f10e41ff611936c475ce8fc61c75f21b69173047623c518f4d69066";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/zapier/email-reply-parser";
        license = licenses.mit;
        description = "Email reply parser";
      };
    };

    "enum34" = python.mkDerivation {
      name = "enum34-1.1.10";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/11/c4/2da1f4952ba476677a42f25cd32ab8aaf0e1c0d0e00b89822b835c7e654c/enum34-1.1.10.tar.gz";
        sha256 = "cce6a7477ed816bd2542d03d53db9f0db935dd013b70f336a95c73979289f248";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://bitbucket.org/stoneleaf/enum34";
        license = licenses.bsdOriginal;
        description = "Python 3.4 Enum backported to 3.3, 3.2, 3.1, 2.7, 2.6, 2.5, and 2.4";
      };
    };

    "funcsigs" = python.mkDerivation {
      name = "funcsigs-1.0.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz";
        sha256 = "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://funcsigs.readthedocs.org";
        license = licenses.asl20;
        description = "Python function signatures from PEP362 for Python 2.6, 2.7 and 3.2+";
      };
    };

    "functools32" = python.mkDerivation {
      name = "functools32-3.2.3.post2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5e/1a/0aa2c8195a204a9f51284018562dea77e25511f02fe924fac202fc012172/functools32-3.2.3-2.zip";
        sha256 = "89d824aa6c358c421a234d7f9ee0bd75933a67c29588ce50aaa3acdf4d403fa0";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/MiCHiLU/python-functools32";
        license = "PSF license";
        description = "Backport of the functools module from Python 3.2.3 for use on 2.7 and PyPy.";
      };
    };

    "futures" = python.mkDerivation {
      name = "futures-3.3.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/47/04/5fc6c74ad114032cd2c544c575bffc17582295e9cd6a851d6026ab4b2c00/futures-3.3.0.tar.gz";
        sha256 = "7e033af76a5e35f58e56da7a91e687706faf4e7bdfb2cbc3f2cca6b9bcda9794";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/agronholm/pythonfutures";
        license = licenses.psfl;
        description = "Backport of the concurrent.futures package from Python 3";
      };
    };

    "google-api-core" = python.mkDerivation {
      name = "google-api-core-1.14.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b6/fe/de51754e6c26afbd8b0c27e92b87bcff57daf6a8985516aee5f139485560/google-api-core-1.14.3.tar.gz";
        sha256 = "df8adc4b97f5ab4328a0e745bee77877cf4a7d4601cb1cd5959d2bbf8fba57aa";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."futures"
        self."google-auth"
        self."googleapis-common-protos"
        self."protobuf"
        self."pytz"
        self."requests"
        self."setuptools"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
        license = licenses.asl20;
        description = "Google API client core library";
      };
    };

    "google-auth" = python.mkDerivation {
      name = "google-auth-1.6.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ef/77/eb1d3288dbe2ba6f4fe50b9bb41770bac514cd2eb91466b56d44a99e2f8d/google-auth-1.6.3.tar.gz";
        sha256 = "0f7c6a64927d34c1a474da92cfc59e552a5d3b940d3266606c6a28b72888b9e4";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."cachetools"
        self."pyasn1-modules"
        self."rsa"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python";
        license = licenses.asl20;
        description = "Google Authentication Library";
      };
    };

    "google-cloud-bigtable" = python.mkDerivation {
      name = "google-cloud-bigtable-0.32.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/79/cd/ecdefd9f9307771102eb3961c54f03af0712ff2e5e23ff2420f31ddcaecf/google-cloud-bigtable-0.32.2.tar.gz";
        sha256 = "40d1fc8009c228f70bd0e2176e73a3f101051ad73889b3d25a5df672c029a8bd";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."google-api-core"
        self."google-cloud-core"
        self."grpc-google-iam-v1"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
        license = licenses.asl20;
        description = "Google Cloud Bigtable API client library";
      };
    };

    "google-cloud-core" = python.mkDerivation {
      name = "google-cloud-core-0.29.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/8f/79/aba910c76b12c13e31be779bb580556757b47ee331efc10e30c4785a2156/google-cloud-core-0.29.1.tar.gz";
        sha256 = "d85b1aaaf3bad9415ad1d8ee5eadce96d7007a82f13ce0a0629a003a11e83f29";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."google-api-core"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
        license = licenses.asl20;
        description = "Google Cloud API client core library";
      };
    };

    "google-cloud-pubsub" = python.mkDerivation {
      name = "google-cloud-pubsub-0.35.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/da/e3/18df6b2f9abc3e0d1d0a16c5ddb5d916ba8de29f669bddc3fcc01f51dff9/google-cloud-pubsub-0.35.4.tar.gz";
        sha256 = "d36cce762db43f99789ae30df19a794e6152a0a7c89d5d331ea9cb0545244c86";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."google-api-core"
        self."grpc-google-iam-v1"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
        license = licenses.asl20;
        description = "Google Cloud Pub/Sub API client library";
      };
    };

    "google-cloud-storage" = python.mkDerivation {
      name = "google-cloud-storage-1.13.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/3b/6e/8babea5290108763d6f5f2dd7e787adeee55a8cf98ffcf35b2487ff93f76/google-cloud-storage-1.13.3.tar.gz";
        sha256 = "c8ab4ff42fa43cedd115e71e1f3ae254af0607bf8da7bd5763824ba78046b1b9";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."google-api-core"
        self."google-cloud-core"
        self."google-resumable-media"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
        license = licenses.asl20;
        description = "Google Cloud Storage API client library";
      };
    };

    "google-resumable-media" = python.mkDerivation {
      name = "google-resumable-media-0.4.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c2/aa/ace464dfd3262e246bf95ec8f79661c1fe70eb2acbf8836e1f0f94a8ee84/google-resumable-media-0.4.1.tar.gz";
        sha256 = "cdeb8fbb3551a665db921023603af2f0d6ac59ad8b48259cb510b8799505775f";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-resumable-media-python";
        license = licenses.asl20;
        description = "Utilities for Google Media Downloads and Resumable Uploads";
      };
    };

    "googleapis-common-protos" = python.mkDerivation {
      name = "googleapis-common-protos-1.6.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/eb/ee/e59e74ecac678a14d6abefb9054f0bbcb318a6452a30df3776f133886d7d/googleapis-common-protos-1.6.0.tar.gz";
        sha256 = "e61b8ed5e36b976b487c6e7b15f31bb10c7a0ca7bd5c0e837f4afab64b53a0c6";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."protobuf"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/googleapis/googleapis";
        license = licenses.asl20;
        description = "Common protobufs used in Google APIs";
      };
    };

    "grpc-google-iam-v1" = python.mkDerivation {
      name = "grpc-google-iam-v1-0.11.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/9b/28/f26f67381cb23e81271b8d66c00a846ad9d25a909ae1ae1df8222fad2744/grpc-google-iam-v1-0.11.4.tar.gz";
        sha256 = "5009e831dcec22f3ff00e89405249d6a838d1449a46ac8224907aa5b0e0b1aec";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."googleapis-common-protos"
        self."grpcio"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/googleapis/googleapis";
        license = licenses.asl20;
        description = "GRPC library for the google-iam-v1 service";
      };
    };

    "grpcio" = python.mkDerivation {
      name = "grpcio-1.30.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5e/29/1bd649737e427a6bb850174293b4f2b72ab80dd49462142db9b81e1e5c7b/grpcio-1.30.0.tar.gz";
        sha256 = "e8f2f5d16e0164c415f1b31a8d9a81f2e4645a43d1b261375d6bab7b0adf511f";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."enum34"
        self."futures"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://grpc.io";
        license = licenses.asl20;
        description = "HTTP/2-based RPC framework";
      };
    };

    "hiredis" = python.mkDerivation {
      name = "hiredis-0.1.6";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/27/d2/5e4d2ac0b3161f00ce7251f51c7cb86dfc51a6fe309e550cabddd6926f65/hiredis-0.1.6.tar.gz";
        sha256 = "b6df262a0231d8172fe1941e589f04e51974b273209bae6d0d8e235daa3b6a35";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/redis/hiredis-py";
        license = licenses.bsdOriginal;
        description = "Python wrapper for hiredis";
      };
    };

    "httplib2" = python.mkDerivation {
      name = "httplib2-0.18.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/98/3f/0769a851fbb0ecc458260055da67d550d3015ebe6b8b861c79ad00147bb9/httplib2-0.18.1.tar.gz";
        sha256 = "8af66c1c52c7ffe1aa5dc4bcd7c769885254b0756e6e69f953c7f0ab49a70ba3";
};
      doCheck = commonDoCheck;
      format = "pyproject";
      buildInputs = commonBuildInputs ++ [
        self."setuptools"
        self."wheel"
      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/httplib2/httplib2";
        license = licenses.mit;
        description = "A comprehensive HTTP client library.";
      };
    };

    "idna" = python.mkDerivation {
      name = "idna-2.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz";
        sha256 = "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kjd/idna";
        license = licenses.bsdOriginal;
        description = "Internationalized Domain Names in Applications (IDNA)";
      };
    };

    "ipaddress" = python.mkDerivation {
      name = "ipaddress-1.0.23";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b9/9a/3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9/ipaddress-1.0.23.tar.gz";
        sha256 = "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/phihag/ipaddress";
        license = licenses.psfl;
        description = "IPv4/IPv6 manipulation library";
      };
    };

    "isodate" = python.mkDerivation {
      name = "isodate-0.6.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz";
        sha256 = "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gweis/isodate/";
        license = licenses.bsdOriginal;
        description = "An ISO 8601 date/time/duration parser and formatter";
      };
    };

    "jmespath" = python.mkDerivation {
      name = "jmespath-0.10.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz";
        sha256 = "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jmespath/jmespath.py";
        license = licenses.mit;
        description = "JSON Matching Expressions";
      };
    };

    "jsonschema" = python.mkDerivation {
      name = "jsonschema-2.6.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/58/b9/171dbb07e18c6346090a37f03c7e74410a1a56123f847efed59af260a298/jsonschema-2.6.0.tar.gz";
        sha256 = "6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."functools32"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/Julian/jsonschema";
        license = licenses.mit;
        description = "An implementation of JSON Schema validation for Python";
      };
    };

    "kombu" = python.mkDerivation {
      name = "kombu-3.0.35";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5f/4f/3859b52f6d465d0d4a767516c924ee4f0e1387498ac8d0c30d9942da3762/kombu-3.0.35.tar.gz";
        sha256 = "22ab336a17962717a5d9470547e5508d4bcf1b6ec10cd9486868daf4e5edb727";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."amqp"
        self."anyjson"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://kombu.readthedocs.org";
        license = licenses.bsdOriginal;
        description = "Messaging library for Python";
      };
    };

    "loremipsum" = python.mkDerivation {
      name = "loremipsum-1.0.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/9b/a3/136acb3ae405ea3ffee0340f0c9975f9cc2b55ec39688ffa91174194fc54/loremipsum-1.0.5.zip";
        sha256 = "a38672c145c0e0790cb40403d46bee695e5e9a0350f0643199a012a18f65449a";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://projects.monkeython.com/loremipsum";
        license = licenses.gpl1;
        description = "UNKNOWN";
      };
    };

    "lxml" = python.mkDerivation {
      name = "lxml-4.3.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/36/14/4e58e16122dd50577a2bfa883c19bd781e223714d55a0d97f56ea506763c/lxml-4.3.5.tar.gz";
        sha256 = "738862e9724d201f1aa8394cb666d8136d666198e97d6e1e5c9876ad884a86b3";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://lxml.de/";
        license = licenses.bsdOriginal;
        description = "Powerful and Pythonic XML processing library combining libxml2/libxslt with the ElementTree API.";
      };
    };

    "maxminddb" = python.mkDerivation {
      name = "maxminddb-1.4.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/83/35/6dc423e0ff354c326849d6d878d104b44be7eec491dcf26787ab3593cd81/maxminddb-1.4.1.tar.gz";
        sha256 = "df1451bcd848199905ac0de4631b3d02d6a655ad28ba5e5a4ca29a23358db712";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."ipaddress"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.maxmind.com/";
        license = licenses.asl20;
        description = "Reader for the MaxMind DB format";
      };
    };

    "milksnake" = python.mkDerivation {
      name = "milksnake-0.1.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f9/6d/b55d227c75643445fb5bcd496ab21e543550330ba58a3d791efe973d39c1/milksnake-0.1.5.zip";
        sha256 = "dfcd43b78bcf93897a75eea1dadf71c848319f19451cff4f3f3a628a5abe1688";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."cffi"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "UNKNOWN";
        license = licenses.asl20;
        description = "A python library that extends setuptools for binary extensions.";
      };
    };

    "mistune" = python.mkDerivation {
      name = "mistune-0.8.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/2d/a4/509f6e7783ddd35482feda27bc7f72e65b5e7dc910eca4ab2164daf9c577/mistune-0.8.4.tar.gz";
        sha256 = "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/lepture/mistune";
        license = licenses.bsdOriginal;
        description = "The fastest markdown parser in pure Python";
      };
    };

    "mmh3" = python.mkDerivation {
      name = "mmh3-2.3.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/87/a9/d15efdb230b1588b9427c77ce4b608aaf478bd0ebd47b2f6a7a1bc7cce4b/mmh3-2.3.1.tar.gz";
        sha256 = "ecadc3557c093211a70b49814cf91d6833fff403edf2d8405645e227262de928";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://packages.python.org/mmh3";
        license = licenses.publicDomain;
        description = "Python library for MurmurHash (MurmurHash3), a set of fast and robust hash functions.";
      };
    };

    "mock" = python.mkDerivation {
      name = "mock-2.0.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz";
        sha256 = "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."funcsigs"
        self."pbr"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/testing-cabal/mock";
        license = licenses.bsdOriginal;
        description = "Rolling backport of unittest.mock for all Pythons";
      };
    };

    "msgpack" = python.mkDerivation {
      name = "msgpack-0.6.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/74/0a/de673c1c987f5779b65ef69052331ec0b0ebd22958bda77a8284be831964/msgpack-0.6.2.tar.gz";
        sha256 = "ea3c2f859346fcd55fc46e96885301d9c2f7a36d453f5d8f2967840efa1e1830";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://msgpack.org/";
        license = licenses.asl20;
        description = "MessagePack (de)serializer.";
      };
    };

    "natsort" = python.mkDerivation {
      name = "natsort-6.2.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/50/ce/288a069b6b097eace8b8b99023c56914004a9d6105841955b051aa3fb809/natsort-6.2.1.tar.gz";
        sha256 = "c5944ffd2343141fa5679b17991c398e15105f3b35bb11beefe66c67e08289d5";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/SethMMorton/natsort";
        license = licenses.mit;
        description = "Simple yet flexible natural sorting in Python.";
      };
    };

    "oauth2" = python.mkDerivation {
      name = "oauth2-1.9.0.post1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/64/19/8b9066e94088e8d06d649e10319349bfca961e87768a525aba4a2627c986/oauth2-1.9.0.post1.tar.gz";
        sha256 = "c006a85e7c60107c7cc6da1b184b5c719f6dd7202098196dfa6e55df669b59bf";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."httplib2"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/joestump/python-oauth2";
        license = licenses.mit;
        description = "library for OAuth version 1.9";
      };
    };

    "oauthlib" = python.mkDerivation {
      name = "oauthlib-3.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/fc/c7/829c73c64d3749da7811c06319458e47f3461944da9d98bb4df1cb1598c2/oauthlib-3.1.0.tar.gz";
        sha256 = "bee41cc35fcca6e988463cacc3bcb8a96224f470ca547e697b604cc697b2f889";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/oauthlib/oauthlib";
        license = licenses.bsdOriginal;
        description = "A generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
      };
    };

    "parsimonious" = python.mkDerivation {
      name = "parsimonious-0.8.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/4a/89/32c55944cd30dff856f16859ee325b13c83c260d0c56c0eed511e8063c87/parsimonious-0.8.0.tar.gz";
        sha256 = "ae0869d72a6e57703f24313a5f5748e73ebff836e6fe8b3ddf34ea0dc00d086b";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/erikrose/parsimonious";
        license = licenses.mit;
        description = "(Soon to be) the fastest pure-Python PEG parser I could muster";
      };
    };

    "pathlib2" = python.mkDerivation {
      name = "pathlib2-2.3.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/94/d8/65c86584e7e97ef824a1845c72bbe95d79f5b306364fa778a3c3e401b309/pathlib2-2.3.5.tar.gz";
        sha256 = "6cd9a47b597b37cc57de1c05e56fb1a1c9cc9fab04fe78c29acd090418529868";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."scandir"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/mcmtroffaes/pathlib2";
        license = licenses.mit;
        description = "Object-oriented filesystem paths";
      };
    };

    "pbr" = python.mkDerivation {
      name = "pbr-5.4.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/8a/a8/bb34d7997eb360bc3e98d201a20b5ef44e54098bb2b8e978ae620d933002/pbr-5.4.5.tar.gz";
        sha256 = "07f558fece33b05caf857474a366dfcc00562bca13dd8b47b2b3e22d9f9bf55c";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://docs.openstack.org/pbr/latest/";
        license = licenses.asl20;
        description = "Python Build Reasonableness";
      };
    };

    "percy" = python.mkDerivation {
      name = "percy-2.0.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/6c/e8/1b856488736db9f1bb8578480f9497f7cf1ede96c6e6e17f29ebef4e78bc/percy-2.0.2.tar.gz";
        sha256 = "6238612dc401fa5c221c0ad7738f7ea43e48fe2695f6423e785ee2bc940f021d";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."requests"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/percy/python-percy-client";
        license = licenses.mit;
        description = "Python client library for visual regression testing with Percy (https://percy.io).";
      };
    };

    "petname" = python.mkDerivation {
      name = "petname-2.6";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/8e/a5/348c90b3fb09d7bd76f7dacf1b92e251d75bfbe715006cb9b84eb23be1b1/petname-2.6.tar.gz";
        sha256 = "981c31ef772356a373640d1bb7c67c102e0159eda14578c67a1c99d5b34c9e4c";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://launchpad.net/python-petname";
        license = "Apache2";
        description = "Generate human-readable, random object names";
      };
    };

    "phabricator" = python.mkDerivation {
      name = "phabricator-0.7.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/94/98/f8ab84ec69776bea7e2346f86e3c033e92a40f8d565b9b16021d1737443f/phabricator-0.7.0.tar.gz";
        sha256 = "7b0417ff6682f898019d40b0ff5fc41bc213440c416ce4ad21ff2743e0e9bb2b";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/disqus/python-phabricator";
        license = "UNKNOWN";
        description = "Phabricator API Bindings";
      };
    };

    "phonenumberslite" = python.mkDerivation {
      name = "phonenumberslite-7.7.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/cc/a0/f2eead21d79cb2f9dc06ab7aac76ae2310e9fbc28fe9b49e02528d41683e/phonenumberslite-7.7.5.tar.gz";
        sha256 = "498229ff6f5420ae3c0b10aacb3e8b6021cffc9a475c411cf42ba989b902f622";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/daviddrysdale/python-phonenumbers";
        license = licenses.asl20;
        description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers.";
      };
    };

    "progressbar2" = python.mkDerivation {
      name = "progressbar2-3.10.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/1c/de/a2f5feaf4048c941070e06e5814cb2adad73cdf47778920cb6c762145f17/progressbar2-3.10.1.tar.gz";
        sha256 = "0bf46fb3e41c1d64698c07f37a306524e3fecae21e9e526168c668b95fef3169";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."python-utils"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "";
        license = "";
        description = "A Python Progressbar library to provide visual (yet text based) progress to";
      };
    };

    "protobuf" = python.mkDerivation {
      name = "protobuf-3.12.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ab/e7/8001b5fc971078a15f57cb56e15b699cb0c0f43b1dffaa2fae39961d80da/protobuf-3.12.2.tar.gz";
        sha256 = "49ef8ab4c27812a89a76fa894fe7a08f42f2147078392c0dee51d4a444ef6df5";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."setuptools"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://developers.google.com/protocol-buffers/";
        license = licenses.bsd3;
        description = "Protocol Buffers";
      };
    };

    "psycopg2-binary" = python.mkDerivation {
      name = "psycopg2-binary-2.8.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/97/00/ed4c82364741031d745867f83820d4f373aa891098a5785841850491c9ba/psycopg2-binary-2.8.5.tar.gz";
        sha256 = "ccdc6a87f32b491129ada4b87a43b1895cf2c20fdb7f98ad979647506ffc41b6";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://psycopg.org/";
        license = licenses.lgpl2;
        description = "psycopg2 - Python-PostgreSQL Database Adapter";
      };
    };

    "pyasn1" = python.mkDerivation {
      name = "pyasn1-0.4.8";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz";
        sha256 = "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1";
        license = licenses.bsdOriginal;
        description = "ASN.1 types and codecs";
      };
    };

    "pyasn1-modules" = python.mkDerivation {
      name = "pyasn1-modules-0.2.8";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz";
        sha256 = "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pyasn1"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1-modules";
        license = licenses.bsdOriginal;
        description = "A collection of ASN.1-based protocols modules.";
      };
    };

    "pycparser" = python.mkDerivation {
      name = "pycparser-2.20";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz";
        sha256 = "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/eliben/pycparser";
        license = licenses.bsdOriginal;
        description = "C parser in Python";
      };
    };

    "pyjwt" = python.mkDerivation {
      name = "pyjwt-1.5.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c9/2a/ffd27735280696f6f244c8d1b4d2dd130511340475a29768ed317f9eaf0c/PyJWT-1.5.3.tar.gz";
        sha256 = "500be75b17a63f70072416843dc80c8821109030be824f4d14758f114978bae7";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/jpadilla/pyjwt";
        license = licenses.mit;
        description = "JSON Web Token implementation in Python";
      };
    };

    "pyopenssl" = python.mkDerivation {
      name = "pyopenssl-19.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/0d/1d/6cc4bd4e79f78be6640fab268555a11af48474fac9df187c3361a1d1d2f0/pyOpenSSL-19.1.0.tar.gz";
        sha256 = "9a24494b2602aaf402be5c9e30a0b82d4a5c67528fe8fb475e3f3bc00dd69507";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."cryptography"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pyopenssl.org/";
        license = licenses.asl20;
        description = "Python wrapper module around the OpenSSL library";
      };
    };

    "pytest-runner" = python.mkDerivation {
      name = "pytest-runner-5.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5b/82/1462f86e6c3600f2471d5f552fcc31e39f17717023df4bab712b4a9db1b3/pytest-runner-5.2.tar.gz";
        sha256 = "96c7e73ead7b93e388c5d614770d2bae6526efd997757d3543fe17b557a0942b";
};
      doCheck = commonDoCheck;
      format = "pyproject";
      buildInputs = commonBuildInputs ++ [
        self."setuptools"
        self."setuptools-scm"
        self."wheel"
      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pytest-dev/pytest-runner/";
        license = licenses.mit;
        description = "Invoke py.test as distutils command with dependency resolution";
      };
    };

    "python-dateutil" = python.mkDerivation {
      name = "python-dateutil-2.8.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz";
        sha256 = "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c";
};
      doCheck = commonDoCheck;
      format = "pyproject";
      buildInputs = commonBuildInputs ++ [
        self."setuptools"
        self."setuptools-scm"
        self."wheel"
      ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://dateutil.readthedocs.io";
        license = licenses.bsdOriginal;
        description = "Extensions to the standard Python datetime module";
      };
    };

    "python-memcached" = python.mkDerivation {
      name = "python-memcached-1.59";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/90/59/5faf6e3cd8a568dd4f737ddae4f2e54204fd8c51f90bf8df99aca6c22318/python-memcached-1.59.tar.gz";
        sha256 = "a2e28637be13ee0bf1a8b6843e7490f9456fd3f2a4cb60471733c7b5d5557e4f";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/linsomniac/python-memcached";
        license = licenses.psfl;
        description = "Pure python memcached client";
      };
    };

    "python-u2flib-server" = python.mkDerivation {
      name = "python-u2flib-server-5.0.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/27/c7/ab44905ecf6300063a4754c9cd3997389fdf5c2c08644ed36c57800c2201/python-u2flib-server-5.0.0.tar.gz";
        sha256 = "9b9044db13fe24abc7a07c2bdb4b7bb541ca275702f43ecbd0d9641c28bcc226";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."cryptography"
        self."enum34"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/Yubico/python-u2flib-server";
        license = licenses.bsdOriginal;
        description = "Python based U2F server library";
      };
    };

    "python-utils" = python.mkDerivation {
      name = "python-utils-2.4.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f3/58/558356395acc737d2deeabf4ea5ad690ac2995a9215a4b270eb218997289/python-utils-2.4.0.tar.gz";
        sha256 = "f21fc09ff58ea5ebd1fd2e8ef7f63e39d456336900f26bdc9334a03a3f7d8089";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/WoLpH/python-utils";
        license = licenses.bsdOriginal;
        description = "Python Utils is a module with some convenient utilities not included with the standard Python install";
      };
    };

    "pytz" = python.mkDerivation {
      name = "pytz-2020.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f4/f6/94fee50f4d54f58637d4b9987a1b862aeb6cd969e73623e02c5c00755577/pytz-2020.1.tar.gz";
        sha256 = "c35965d010ce31b23eeb663ed3cc8c906275d6be1a34393a1d73a41febf4a048";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pythonhosted.org/pytz";
        license = licenses.mit;
        description = "World timezone definitions, modern and historical";
      };
    };

    "pyyaml" = python.mkDerivation {
      name = "pyyaml-5.3.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz";
        sha256 = "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/yaml/pyyaml";
        license = licenses.mit;
        description = "YAML parser and emitter for Python";
      };
    };

    "qrcode" = python.mkDerivation {
      name = "qrcode-5.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/87/16/99038537dc58c87b136779c0e06d46887ff5104eb8c64989aac1ec8cba81/qrcode-5.3.tar.gz";
        sha256 = "4115ccee832620df16b659d4653568331015c718a754855caf5930805d76924e";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/lincolnloop/python-qrcode";
        license = licenses.bsdOriginal;
        description = "QR Code image generator";
      };
    };

    "querystring-parser" = python.mkDerivation {
      name = "querystring-parser-1.2.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/4a/fa/f54f5662e0eababf0c49e92fd94bf178888562c0e7b677c8941bbbcd1bd6/querystring_parser-1.2.4.tar.gz";
        sha256 = "644fce1cffe0530453b43a83a38094dbe422ccba8c9b2f2a1c00280e14ca8a62";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/bernii/querystring-parser";
        license = licenses.mit;
        description = "QueryString parser for Python/Django that correctly handles nested dictionaries";
      };
    };

    "rb" = python.mkDerivation {
      name = "rb-1.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/9b/46/836de43cf61c4d1d05b1ddda3311d045d254da64d6439150b74a44a7e4ae/rb-1.7.tar.gz";
        sha256 = "2911acac65fdd5aad0b97d3d2c8999ec859214f62bb6d5a220e0aa96828a58ea";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."redis"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/getsentry/rb";
        license = licenses.asl20;
        description = "rb, the redis blaster";
      };
    };

    "redis" = python.mkDerivation {
      name = "redis-2.10.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/68/44/5efe9e98ad83ef5b742ce62a15bea609ed5a0d1caf35b79257ddb324031a/redis-2.10.5.tar.gz";
        sha256 = "5dfbae6acfc54edf0a7a415b99e0b21c0a3c27a7f787b292eea727b1facc5533";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/andymccurdy/redis-py";
        license = licenses.mit;
        description = "Python client for Redis key-value store";
      };
    };

    "redis-py-cluster" = python.mkDerivation {
      name = "redis-py-cluster-1.3.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/1d/4d/a0fcd8ff2d9fc81977810e5f5e2cda5a00086060a4484db1c361393206f0/redis-py-cluster-1.3.4.tar.gz";
        sha256 = "3189ddde3a04f86f4322026c45a159411bda8f84ababe2c8e8e1fbdcb025f358";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."redis"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/grokzen/redis-py-cluster";
        license = licenses.mit;
        description = "Cluster library for redis 3.0.0 built on top of redis-py lib";
      };
    };

    "requests" = python.mkDerivation {
      name = "requests-2.20.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/40/35/298c36d839547b50822985a2cf0611b3b978a5ab7a5af5562b8ebe3e1369/requests-2.20.1.tar.gz";
        sha256 = "ea881206e59f41dbd0bd445437d792e43906703fff75ca8ff43ccdb11f33f263";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."certifi"
        self."chardet"
        self."idna"
        self."urllib3"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://python-requests.org";
        license = licenses.asl20;
        description = "Python HTTP for Humans.";
      };
    };

    "requests-oauthlib" = python.mkDerivation {
      name = "requests-oauthlib-0.3.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/0f/8a/a7afc508dd7cf6883fb318bdf0c2a0fd65443e396ccd27977c6f146040a3/requests-oauthlib-0.3.3.tar.gz";
        sha256 = "37557b4de3eef50d2a4c65dc9382148b8331f04b1c637c414b3355feb0f007e9";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."oauthlib"
        self."requests"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/requests/requests-oauthlib";
        license = licenses.bsdOriginal;
        description = "OAuthlib authentication support for Requests.";
      };
    };

    "rsa" = python.mkDerivation {
      name = "rsa-4.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f7/1a/7837a99fbbe0f48c8e0e15d5418fd8981dbda68286a55b9838e218bd085d/rsa-4.5.tar.gz";
        sha256 = "4d409f5a7d78530a4a2062574c7bd80311bc3af29b364e293aa9b03eea77714f";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pyasn1"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://stuvel.eu/rsa";
        license = licenses.asl20;
        description = "Pure-Python RSA implementation";
      };
    };

    "s3transfer" = python.mkDerivation {
      name = "s3transfer-0.1.13";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/9a/66/c6a5ae4dbbaf253bd662921b805e4972451a6d214d0dc9fb3300cb642320/s3transfer-0.1.13.tar.gz";
        sha256 = "90dc18e028989c609146e241ea153250be451e05ecc0c2832565231dacdf59c1";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."botocore"
        self."futures"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/s3transfer";
        license = licenses.asl20;
        description = "An Amazon S3 Transfer Manager";
      };
    };

    "scandir" = python.mkDerivation {
      name = "scandir-1.10.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/df/f5/9c052db7bd54d0cbf1bc0bb6554362bba1012d03e5888950a4f5c5dadc4e/scandir-1.10.0.tar.gz";
        sha256 = "4d4631f6062e658e9007ab3149a9b914f3548cb38bfb021c64f39a025ce578ae";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/benhoyt/scandir";
        license = licenses.bsdOriginal;
        description = "scandir, a better directory iterator and faster os.walk()";
      };
    };

    "selenium" = python.mkDerivation {
      name = "selenium-3.141.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ed/9c/9030520bf6ff0b4c98988448a93c04fcbd5b13cd9520074d8ed53569ccfe/selenium-3.141.0.tar.gz";
        sha256 = "deaf32b60ad91a4611b98d8002757f29e6f2c2d5fcaf202e1c9ad06d6772300d";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."urllib3"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/SeleniumHQ/selenium/";
        license = licenses.asl20;
        description = "Python bindings for Selenium";
      };
    };

    "sentry-sdk" = python.mkDerivation {
      name = "sentry-sdk-0.15.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/db/bf/4c16b09f4ae93643a3ffee997a9a7c9ff9f1d42e7d0bc1b3e98b2a399abe/sentry-sdk-0.15.1.tar.gz";
        sha256 = "3ac0c430761b3cb7682ce612151d829f8644bb3830d4e530c75b02ceb745ff49";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."certifi"
        self."urllib3"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/getsentry/sentry-python";
        license = licenses.bsdOriginal;
        description = "Python client for Sentry (https://getsentry.com)";
      };
    };

    "setproctitle" = python.mkDerivation {
      name = "setproctitle-1.1.10";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz";
        sha256 = "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/dvarrazzo/py-setproctitle";
        license = licenses.bsdOriginal;
        description = "A Python module to customize the process title";
      };
    };

    "setuptools" = python.mkDerivation {
      name = "setuptools-44.1.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b2/40/4e00501c204b457f10fe410da0c97537214b2265247bc9a5bc6edd55b9e4/setuptools-44.1.1.zip";
        sha256 = "c67aa55db532a0dadc4d2e20ba9961cbd3ccc84d544e9029699822542b5a476b";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pypa/setuptools";
        license = licenses.mit;
        description = "Easily download, build, install, upgrade, and uninstall Python packages";
      };
    };

    "setuptools-scm" = python.mkDerivation {
      name = "setuptools-scm-4.1.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/cd/66/fa77e809b7cb1c2e14b48c7fc8a8cd657a27f4f9abb848df0c967b6e4e11/setuptools_scm-4.1.2.tar.gz";
        sha256 = "a8994582e716ec690f33fec70cca0f85bd23ec974e3f783233e4879090a7faa8";
};
      doCheck = commonDoCheck;
      format = "pyproject";
      buildInputs = commonBuildInputs ++ [
        self."setuptools"
        self."wheel"
      ];
      propagatedBuildInputs = [
        self."setuptools"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pypa/setuptools_scm/";
        license = licenses.mit;
        description = "the blessed package to manage your versions by scm tags";
      };
    };

    "simplejson" = python.mkDerivation {
      name = "simplejson-3.8.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f0/07/26b519e6ebb03c2a74989f7571e6ae6b82e9d7d81b8de6fcdbfc643c7b58/simplejson-3.8.2.tar.gz";
        sha256 = "d58439c548433adcda98e695be53e526ba940a4b9c44fb9a05d92cd495cdd47f";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/simplejson/simplejson";
        license = licenses.mit;
        description = "Simple, fast, extensible JSON encoder/decoder for Python";
      };
    };

    "six" = python.mkDerivation {
      name = "six-1.10.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz";
        sha256 = "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pypi.python.org/pypi/six/";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };

    "soupsieve" = python.mkDerivation {
      name = "soupsieve-1.9.6";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/71/a0/b40ed5dcd4f64c521cdc29cfa7c4847f521c590f7835099307089eaef3ad/soupsieve-1.9.6.tar.gz";
        sha256 = "7985bacc98c34923a439967c1a602dc4f1e15f923b6fcf02344184f86cc7efaa";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."backports-functools-lru-cache"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/facelessuser/soupsieve";
        license = licenses.mit;
        description = "A modern CSS selector implementation for Beautiful Soup.";
      };
    };

    "sqlparse" = python.mkDerivation {
      name = "sqlparse-0.2.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/79/3c/2ad76ba49f9e3d88d2b58e135b7821d93741856d1fe49970171f73529303/sqlparse-0.2.4.tar.gz";
        sha256 = "ce028444cfab83be538752a2ffdb56bc417b7784ff35bb9a3062413717807dec";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/andialbrecht/sqlparse";
        license = licenses.bsdOriginal;
        description = "Non-validating SQL parser";
      };
    };

    "statsd" = python.mkDerivation {
      name = "statsd-3.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b7/10/a1afbd9523c79a44686fb654ab6547007ae57a2ad669caa76f7c291324c7/statsd-3.1.tar.gz";
        sha256 = "fbae5feb33ae9394c275bc834ab94684b94de03acc8f36387bd0bf0c51ef28ee";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jsocol/pystatsd";
        license = licenses.mit;
        description = "A simple statsd client.";
      };
    };

    "strict-rfc3339" = python.mkDerivation {
      name = "strict-rfc3339-0.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/56/e4/879ef1dbd6ddea1c77c0078cd59b503368b0456bcca7d063a870ca2119d3/strict-rfc3339-0.7.tar.gz";
        sha256 = "5cad17bedfc3af57b399db0fed32771f18fc54bbd917e85546088607ac5e1277";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.danielrichman.co.uk/libraries/strict-rfc3339.html";
        license = licenses.gpl3;
        description = "Strict, simple, lightweight RFC3339 functions";
      };
    };

    "structlog" = python.mkDerivation {
      name = "structlog-16.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/3d/d8/90e87637a53ebcb0bbc78b76bceea2f7e8bd98de80feefec7471e38dccf2/structlog-16.1.0.tar.gz";
        sha256 = "b44dfaadcbab84e6bb97bd9b263f61534a79611014679757cd93e2359ee7be01";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.structlog.org/";
        license = licenses.asl20;
        description = "Structured Logging for Python";
      };
    };

    "toml" = python.mkDerivation {
      name = "toml-0.10.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/da/24/84d5c108e818ca294efe7c1ce237b42118643ce58a14d2462b3b2e3800d5/toml-0.10.1.tar.gz";
        sha256 = "926b612be1e5ce0634a2ca03470f95169cf16f939018233a670519cb4ac58b0f";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/uiri/toml";
        license = licenses.mit;
        description = "Python Library for Tom's Obvious, Minimal Language";
      };
    };

    "toronado" = python.mkDerivation {
      name = "toronado-0.0.11";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/72/7d/988c46ca0405b1bc86d87314d81151b814f67608288cae0c19aed1c170a7/toronado-0.0.11.tar.gz";
        sha256 = "7985dc9a13c969fa1372d600455a86709fb6a124dca58c759b6b42e892ddb0a8";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."cssselect"
        self."cssutils"
        self."lxml"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "UNKNOWN";
        license = licenses.asl20;
        description = "Fast lxml-based CSS stylesheet inliner.";
      };
    };

    "ua-parser" = python.mkDerivation {
      name = "ua-parser-0.7.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a3/b4/3d31176d3cb2807635175004e0381fb72351173ec8c9c043b80399cf33a6/ua-parser-0.7.3.tar.gz";
        sha256 = "0aafb05a67b621eb4d69f6c1c3972f2d9443982bcd9132a8b665d90cd48a1add";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/ua-parser/uap-python";
        license = licenses.asl20;
        description = "Python port of Browserscope's user agent parser";
      };
    };

    "unidiff" = python.mkDerivation {
      name = "unidiff-0.6.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/03/d7/fd62a2090ed067b90a5f83354729d0fff1aff27ec718796d2fadb1afa3ae/unidiff-0.6.0.tar.gz";
        sha256 = "90c5214e9a357ff4b2fee19d91e77706638e3e00592a732d9405ea4e93da981f";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/matiasb/python-unidiff";
        license = licenses.mit;
        description = "Unified diff parsing/metadata extraction library.";
      };
    };

    "urllib3" = python.mkDerivation {
      name = "urllib3-1.24.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/fd/fa/b21f4f03176463a6cccdb612a5ff71b927e5224e83483012747c12fc5d62/urllib3-1.24.2.tar.gz";
        sha256 = "9a247273df709c4fedb38c711e44292304f73f39ab01beda9f6b9fc375669ac3";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://urllib3.readthedocs.io/";
        license = licenses.mit;
        description = "HTTP library with thread-safe connection pooling, file post, and more.";
      };
    };

    "uwsgi" = python.mkDerivation {
      name = "uwsgi-2.0.19.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c7/75/45234f7b441c59b1eefd31ba3d1041a7e3c89602af24488e2a22e11e7259/uWSGI-2.0.19.1.tar.gz";
        sha256 = "faa85e053c0b1be4d5585b0858d3a511d2cd10201802e8676060fd0a109e5869";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://uwsgi-docs.readthedocs.io/en/latest/";
        license = licenses.gpl2Plus;
        description = "The uWSGI server";
      };
    };

    "vcversioner" = python.mkDerivation {
      name = "vcversioner-2.16.0.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c5/cc/33162c0a7b28a4d8c83da07bc2b12cee58c120b4a9e8bba31c41c8d35a16/vcversioner-2.16.0.0.tar.gz";
        sha256 = "dae60c17a479781f44a4010701833f1829140b1eeccd258762a74974aa06e19b";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/habnabit/vcversioner";
        license = licenses.isc;
        description = "Use version control tags to discover version numbers";
      };
    };

    "wheel" = python.mkDerivation {
      name = "wheel-0.34.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/75/28/521c6dc7fef23a68368efefdcd682f5b3d1d58c2b90b06dc1d0b805b51ae/wheel-0.34.2.tar.gz";
        sha256 = "8788e9155fe14f54164c1b9eb0a319d98ef02c160725587ad60f14ddc57b6f96";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [
        self."setuptools"
      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pypa/wheel";
        license = licenses.mit;
        description = "A built-package format for Python";
      };
    };
  };
  localOverridesFile = ./requirements_override.nix;
  localOverrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [
        (let src = pkgs.fetchFromGitHub { owner = "nix-community"; repo = "pypi2nix-overrides"; rev = "90e891e83ffd9e55917c48d24624454620d112f0"; sha256 = "0cl1r3sxibgn1ks9xyf5n3rdawq4hlcw4n6xfhg3s1kknz54jp9y"; } ; in import "${src}/overrides.nix" { inherit pkgs python; })
  ];
  paramOverrides = [
    (overrides { inherit pkgs python; })
  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [localOverrides] else [] ) ++ commonOverrides ++ paramOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )