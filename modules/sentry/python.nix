let
  fetchPypiSrc = builtins.fetchTarball {
    name = "nix-pypi-fetcher";
    url = "https://github.com/DavHau/nix-pypi-fetcher/tarball/cb8e720224621b6144fd517505c91a0ea2d10e72";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "19chafa7gvzz58fnd0l3mfpizs01zz4cdq4851plgw8qsmx9df9i";
  };
  fetchPypi = import (fetchPypiSrc);
  nixpkgs_src = builtins.fetchTarball {
    name = "nixpkgs";
    url = "https://github.com/nixos/nixpkgs/tarball/60c4ddb97fd5a730b93d759754c495e1fe8a3544";
    sha256 = "1a1pvfz130c4cma5a21wjl7yrivc7ls1ksqqmac23srk64ipzakf";
  };
  pkgs = import nixpkgs_src { config = {}; };
  python = pkgs.python27;
  overlay = self: super: {
    python27 = super.python27.override {
      packageOverrides = python-self: python-super: rec {
        backports.functools-lru-cache = python.pkgs.buildPythonPackage {
          name = "backports.functools-lru-cache-1.6.1";
          src = fetchPypi "backports.functools-lru-cache" "1.6.1";
          buildInputs = [ python-self.setuptools_scm ];
          doCheck = false;
          doInstallCheck = false;
        };
        boto3 = python-super.boto3.overrideAttrs ( oldAttrs: {
          name = "boto3-1.9.205";
          src = fetchPypi "boto3" "1.9.205";
          propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ python-self.botocore python-self.jmespath python-self.s3transfer ];
          doCheck = false;
          doInstallCheck = false;
        });
        boto = boto3;
        croniter = python.pkgs.buildPythonPackage {
          name = "croniter-0.3.31";
          src = fetchPypi "croniter" "0.3.31";
          propagatedBuildInputs = [ python-self.python-dateutil ];
          doCheck = false;
          doInstallCheck = false;
        };
        cssselect = python-super.cssselect.overrideAttrs ( oldAttrs: {
          name = "cssselect-1.1.0";
          src = fetchPypi "cssselect" "1.1.0";
          doCheck = false;
          doInstallCheck = false;
        });
        cssselect2 = cssselect;
        django_1_8 = python-super.django_1_8.overrideAttrs ( oldAttrs: {
          name = "django-1.8.19";
          src = fetchPypi "django" "1.8.19";
          doCheck = false;
          doInstallCheck = false;
        });
        django = django_1_8;
        django-crispy-forms = python.pkgs.buildPythonPackage {
          name = "django-crispy-forms-1.9.0";
          src = fetchPypi "django-crispy-forms" "1.9.0";
          doCheck = false;
          doInstallCheck = false;
        };
        django-picklefield = python-super.django-picklefield.overrideAttrs ( oldAttrs: {
          name = "django-picklefield-1.1.0";
          src = fetchPypi "django-picklefield" "1.1.0";
          doCheck = false;
          doInstallCheck = false;
        });
        django-sudo = python.pkgs.buildPythonPackage {
          name = "django-sudo-3.1.0";
          src = fetchPypi "django-sudo" "3.1.0";
          doCheck = false;
          doInstallCheck = false;
        };
        email-reply-parser = python.pkgs.buildPythonPackage {
          name = "email-reply-parser-0.5.9";
          src = fetchPypi "email-reply-parser" "0.5.9";
          doCheck = false;
          doInstallCheck = false;
        };
        enum34 = python-super.enum34.overrideAttrs ( oldAttrs: {
          name = "enum34-1.1.6";
          src = fetchPypi "enum34" "1.1.6";
          doCheck = false;
          doInstallCheck = false;
        });
        enum = enum34;
        future = python-super.future.overrideAttrs ( oldAttrs: {
          name = "future-0.16.0";
          src = fetchPypi "future" "0.16.0";
          doCheck = false;
          doInstallCheck = false;
        });
        google_cloud_bigtable = python-super.google_cloud_bigtable.overrideAttrs ( oldAttrs: {
          name = "google-cloud-bigtable-0.27.0";
          src = fetchPypi "google-cloud-bigtable" "0.27.0";
          propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ google-gax python-self.google_cloud_core ];
          doCheck = false;
          doInstallCheck = false;
        });
        google_cloud_core = python-super.google_cloud_core.overrideAttrs ( oldAttrs: {
          name = "google-cloud-core-0.27.1";
          src = fetchPypi "google-cloud-core" "0.27.1";
          propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ python-self.futures python-self.google_auth python-self.googleapis_common_protos python-self.protobuf python-self.requests python-self.setuptools python-self.six ];
          doCheck = false;
          doInstallCheck = false;
        });
        google_cloud_storage = python-super.google_cloud_storage.overrideAttrs ( oldAttrs: {
          name = "google-cloud-storage-1.5.0";
          src = fetchPypi "google-cloud-storage" "1.5.0";
          propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ python-self.google_auth python-self.google_cloud_core python-self.google_resumable_media python-self.requests ];
          doCheck = false;
          doInstallCheck = false;
        });
        google-gax = python.pkgs.buildPythonPackage {
          name = "google-gax-0.15.16";
          src = fetchPypi "google-gax" "0.15.16";
          propagatedBuildInputs = [ future ply python-self.dill python-self.google_auth python-self.googleapis_common_protos python-self.grpcio python-self.protobuf python-self.requests ];
          doCheck = false;
          doInstallCheck = false;
        };
        googleapis_common_protos = python-super.googleapis_common_protos.overrideAttrs ( oldAttrs: {
          name = "googleapis-common-protos-1.6.0";
          src = fetchPypi "googleapis-common-protos" "1.6.0";
          propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ python-self.protobuf ];
          doCheck = false;
          doInstallCheck = false;
        });
        mmh3 = python.pkgs.buildPythonPackage {
          name = "mmh3-2.5.1";
          src = fetchPypi "mmh3" "2.5.1";
          doCheck = false;
          doInstallCheck = false;
        };
        petname = python.pkgs.buildPythonPackage {
          name = "petname-2.6";
          src = fetchPypi "petname" "2.6";
          doCheck = false;
          doInstallCheck = false;
        };
        phonenumberslite = python.pkgs.buildPythonPackage {
          name = "phonenumberslite-8.12.1";
          src = fetchPypi "phonenumberslite" "8.12.1";
          doCheck = false;
          doInstallCheck = false;
        };
        ply = python-super.ply.overrideAttrs ( oldAttrs: {
          name = "ply-3.8";
          src = fetchPypi "ply" "3.8";
          doCheck = false;
          doInstallCheck = false;
        });
        progressbar33 = python-super.progressbar33.overrideAttrs ( oldAttrs: {
          name = "progressbar2-2.4.0";
          src = fetchPypi "progressbar2" "2.4.0";
          doCheck = false;
          doInstallCheck = false;
        });
        progressbar = progressbar33;
        progressbar2 = progressbar33;
        progressbar231 = progressbar33;
        psycopg2-binary = python.pkgs.buildPythonPackage {
          name = "psycopg2-binary-2.8.5";
          src = fetchPypi "psycopg2-binary" "2.8.5";
          doCheck = false;
          doInstallCheck = false;
        };
        python-memcached = python.pkgs.buildPythonPackage {
          name = "python-memcached-1.59";
          src = fetchPypi "python-memcached" "1.59";
          propagatedBuildInputs = [ python-self.six ];
          doCheck = false;
          doInstallCheck = false;
        };
        python-u2flib-server = python.pkgs.buildPythonPackage {
          name = "python-u2flib-server-5.0.0";
          src = fetchPypi "python-u2flib-server" "5.0.0";
          propagatedBuildInputs = [ enum34 python-self.cryptography python-self.six ];
          doCheck = false;
          doInstallCheck = false;
        };
        python3-saml = python.pkgs.buildPythonPackage {
          name = "python3-saml-1.9.0";
          src = fetchPypi "python3-saml" "1.9.0";
          propagatedBuildInputs = [ xmlsec python-self.defusedxml python-self.isodate ];
          doCheck = false;
          doInstallCheck = false;
        };
        pyyaml_3 = python-super.pyyaml_3.overrideAttrs ( oldAttrs: {
          name = "pyyaml-3.13";
          src = fetchPypi "pyyaml" "3.13";
          doCheck = false;
          doInstallCheck = false;
        });
        pyyaml = pyyaml_3;
        querystring-parser = python.pkgs.buildPythonPackage {
          name = "querystring-parser-1.2.4";
          src = fetchPypi "querystring-parser" "1.2.4";
          propagatedBuildInputs = [ python-self.six ];
          doCheck = false;
          doInstallCheck = false;
        };
        rb = python.pkgs.buildPythonPackage {
          name = "rb-1.7";
          src = fetchPypi "rb" "1.7";
          propagatedBuildInputs = [ redis ];
          doCheck = false;
          doInstallCheck = false;
        };
        redis = python-super.redis.overrideAttrs ( oldAttrs: {
          name = "redis-3.0.1";
          src = fetchPypi "redis" "3.0.1";
          doCheck = false;
          doInstallCheck = false;
        });
        redis-py-cluster = python.pkgs.buildPythonPackage {
          name = "redis-py-cluster-2.0.0";
          src = fetchPypi "redis-py-cluster" "2.0.0";
          propagatedBuildInputs = [ redis ];
          doCheck = false;
          doInstallCheck = false;
        };
        simplejson = python-super.simplejson.overrideAttrs ( oldAttrs: {
          name = "simplejson-3.17.0";
          src = fetchPypi "simplejson" "3.17.0";
          doCheck = false;
          doInstallCheck = false;
        });
        symbolic = python.pkgs.buildPythonPackage {
          name = "symbolic-7.2.0";
          src = fetchPypi "symbolic" "7.2.0";
          buildInputs = [ python-self.milksnake ];
          propagatedBuildInputs = [ python-self.milksnake ];
          doCheck = false;
          doInstallCheck = false;
        };
        toronado = python.pkgs.buildPythonPackage {
          name = "toronado-0.0.11";
          src = fetchPypi "toronado" "0.0.11";
          propagatedBuildInputs = [ cssselect python-self.cssutils python-self.lxml ];
          doCheck = false;
          doInstallCheck = false;
        };
        xmlsec = python.pkgs.buildPythonPackage {
          name = "xmlsec-1.3.3";
          src = fetchPypi "xmlsec" "1.3.3";
          buildInputs = [ python-self.lxml python-self.pkgconfig ];
          propagatedBuildInputs = [ python-self.lxml python-self.pkgconfig ];
          doCheck = false;
          doInstallCheck = false;
        };
      };
    };
  };
in

with import nixpkgs_src { overlays = [ overlay ]; };

python27.withPackages (ps: with ps; [
  beautifulsoup4
  boto3
  botocore
  celery
  cffi
  click
  confluent-kafka
  croniter
  cssselect
  cssutils
  datadog
  django_1_8
  django-crispy-forms
  django-picklefield
  django-sudo
  djangorestframework
  email-reply-parser
  futures
  google_api_core
  google_auth
  google_cloud_bigtable
  google_cloud_core
  google_cloud_storage
  googleapis_common_protos
  ipaddress
  jsonschema
  kombu
  lxml
  mistune
  mmh3
  msgpack
  parsimonious
  petname
  phonenumberslite
  pillow
  progressbar33
  psycopg2-binary
  pyjwt
  python-dateutil
  python-memcached
  python-u2flib-server
  python3-saml
  pyyaml_3
  qrcode
  querystring-parser
  rb
  redis
  redis-py-cluster
  requests
  requests_oauthlib
  sentry-sdk
  simplejson
  six
  sqlparse
  statsd
  structlog
  symbolic
  toronado
  urllib3
])
