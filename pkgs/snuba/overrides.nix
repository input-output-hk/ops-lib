{ lib
, iana-etc
, libredirect
, ncurses
, fetchFromGitHub
, writeText
, glibcLocales
}:

self: super:

{
  pytz = super.pytz.overrideAttrs(oldDrv: rec {
    version = "2018.4";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0jgpqx3kk2rhv81j1izjxvmx8d0x7hzs1857pgqnixic5wq2ar60";
    };
  });

  pathlib2 = super.pathlib2.overrideAttrs(oldDrv: rec {
    version = "2.3.2";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "10yb0iv5x2hs631rcppkhbddx799d3h8pcwmkbh2a66ns3w71ccf";
    };
  });

  ipython = super.ipython.overrideAttrs(oldDrv: rec {
    version = "6.4.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0p2yaa5hxy6ag06aipq4a0rmqbz4z0ma3pjaxwpwlajrc6m3g9gc";
    };

    propagatedBuildInputs
      = [ self.simplegeneric
          self.decorator
          self.traitlets
          self.jedi
          self.pexpect
          self.pickleshare
          self.prompt_toolkit
          self.backcall
          self.pygments
        ];
  });

  prompt_toolkit = super.prompt_toolkit.overrideAttrs(oldDrv: rec {
    version = "1.0.18";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "09h1153wgr5x2ny7ds0w2m81n3bb9j8hjb8sjfnrg506r01clkyx";
    };
  });

  pickleshare = super.pickleshare.overrideAttrs(oldDrv: rec {
    version = "0.7.4";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0yvk14dzxk7g6qpr7iw23vzqbsr0dh4ij4xynkhnzpfz4xr2bac4";
    };
  });

  argh = super.argh.overrideAttrs(oldDrv: rec {
    version = "0.26.2";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0rdv0n2aa181mkrybwvl3czkrrikgzd4y2cri6j735fwhj65nlz9";
    };
  });
  astroid = with self; buildPythonPackage rec {
    pname = "astroid";
    version = "2.2.5";

    disabled = pythonOlder "3.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1x5c8fiqa18frwwfdsw41lpqsyff3w4lxvjx9d5ccs4zfkhy2q35";
    };

    # From astroid/__pkginfo__.py
    propagatedBuildInputs = [ lazy-object-proxy six wrapt ]
      ++ lib.optional (pythonOlder "3.5") typing
      ++ lib.optional (!isPyPy) typed-ast;

    checkInputs = [ pytestrunner pytest ];

    meta = with lib; {
      description = "An abstract syntax tree for Python with inference support";
      homepage = https://github.com/PyCQA/astroid;
      license = licenses.lgpl2;
      platforms = platforms.all;
      maintainers = with maintainers; [ nand0p ];
    };
  };
  # astroid = super.astroid.overrideAttrs(oldDrv: rec {
  #   version = "1.6.6";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "1ir4n736x36iyg8rq263bwszamlncfh7xz94gpxxkwa4gzy6jn6j";
  #   };

  #   propagatedBuildInputs = [ self.lazy-object-proxy self.wrapt ];
  # });
  atomicwrites = super.atomicwrites.overrideAttrs(oldDrv: rec {
    version = "1.1.5";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "11bm90fwm2avvf4f3ib8g925w7jr4m11vcsinn1bi6ns4bm32214";
    };
  });
  attrs = super.attrs.overrideAttrs(oldDrv: rec {
    version = "18.1.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0yzqz8wv3w1srav5683a55v49i0szkm47dyrnkd56fqs8j8ypl70";
    };
  });
  autopep8 = super.autopep8.overrideAttrs(oldDrv: rec {
    version = "1.3.5";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "2284d4ae2052fedb9f466c09728e30d2e231cfded5ffd7b1a20c34123fdc4ba4";
    };
  });
  # backcall = super.backcall.overrideAttrs(oldDrv: rec {
  #   version = "0.1.0";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "0yzqz8wv3w1srav5683a55v49i0szkm47dyrnkd56fqs8j8ypl70";
  #   };

  #   propagatedBuildInputs = [ self.hypothesis self.zope ];
  # });
  # zope = self.buildPythonPackage rec {
  #   pname = "Zope";
  #   version = "4.4.2";

  #   src = self.fetchPypi {
  #     inherit pname version;
  #     sha256 = "0fl1j46w9hi9ab26h1d5ncx54qsm6zfjczr1k6wcfh5qirvs3hn5";
  #   };

  #   propagatedBuildInputs = [ self.zope_browserresource ];
  # };
  # zope_browserresource = self.buildPythonPackage rec {
  #   pname = "zope.browserresource";
  #   version = "3.12.0";

  #   src = self.fetchPypi {
  #     inherit pname version;
  #     sha256 = "1111111111111111111111111111111111111111111111111111";
  #   };
  # };
  # black = super.black.overrideAttrs(oldDrv: rec {
  #   version = "19.10b0";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "c2edb73a08e9e0e6f65a0e6af18b059b8b1cdd5bef997d7a0b181df93dc81539";
  #   };
  # });
  blinker = super.blinker.overrideAttrs(oldDrv: rec {
    version = "1.4";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1dpq0vb01p36jjwbhhd08ylvrnyvcc82yxx3mwjx6awrycjyw6j7";
    };
  });
  certifi = super.certifi.overrideAttrs(oldDrv: rec {
    version = "2018.4.16";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1dqvqrzsf2wq58nigq2g9a9x0akq7a28219b2a4rznwk8bsrirhk";
    };
  });
  # chardet = super.chardet.overrideAttrs(oldDrv: rec {
  #   version = "3.0.4";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "1bpalpia6r5x1kknbk11p1fzph56fmmnp405ds8icksd3knr5aw4";
  #   };
  # });
  click = super.click.overrideAttrs(oldDrv: rec {
    version = "6.7";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "02qkfpykbq35id8glfgwc38yc430427yd05z1wc5cnld8zgicmgi";
    };
  });
  clickhouse_driver = self.buildPythonPackage rec {
    pname = "clickhouse-driver";
    version = "0.1.1";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "3eeb6d2683b38755dcccef117b1361356b5e29619766f9463c68fe10f5e72cf1";
    };

    propagatedBuildInputs = [ self.pytz self.clickhouse_cityhash self.zstd self.lz4 ];
    checkInputs = [ self.freezegun self.mock self.nose ];
  };
  clickhouse_cityhash = self.buildPythonPackage rec {
    pname = "clickhouse-cityhash";
    version = "1.0.2.3";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "2f377d20796c6fe4bc1c5b4e07082782788401f14677febc35305ce129a0167d";
    };
  };
  colorama = super.colorama.overrideAttrs(oldDrv: rec {
    version = "0.3.9";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1wd1szk0z3073ghx26ynw43gnc140ibln1safgsis6s6z3s25ss8";
    };
  });
  configparser = super.configparser.overrideAttrs(oldDrv: rec {
    version = "3.5.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0fi7vf09vi1588jd8f16a021m5y6ih2hy7rpbjb408xw45qb822k";
    };
  });
  confluent-kafka = super.confluent-kafka.overrideAttrs(oldDrv: rec {
    version = "1.2.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1nn8z7ggjj04v97jm33dxh2cv2azy4xi1hwkj9qwbbc68vasc3cp";
    };
  });
  contextlib2 = super.contextlib2.overrideAttrs(oldDrv: rec {
    version = "0.5.5";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0j6ad6lwwyc9kv71skj098v5l7x5biyj2hs4lc5x1kcixqcr97sh";
    };
  });
  coverage = super.coverage.overrideAttrs(oldDrv: rec {
    version = "4.5.1";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1wbrzpxka3xd4nmmkc6q0ir343d91kymwsm8pbmwa0d2a7q4ir2n";
    };
  });
  datadog = super.datadog;
  decorator = with self; buildPythonPackage rec {
    pname = "decorator";
    version = "4.3.0";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0308djallnh00v112y5b7nadl657ysmkp6vc8xn51d6yzc9zm7n3";
    };

    meta = with lib; {
      homepage = https://pypi.python.org/pypi/decorator;
      description = "Better living through Python with decorators";
      license = lib.licenses.mit;
      maintainers = [ maintainers.costrouc ];
    };
  };
  deprecation = super.deprecation.overrideAttrs(oldDrv: rec {
    version = "2.0.3";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0yc4ivzivgvk371cii9rzppxdiv3978lp4r3zzhd7rakmawq0cdg";
    };
  });
  docopt = super.docopt.overrideAttrs(oldDrv: rec {
    version = "0.6.2";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "14f4hn6d1j4b99svwbaji8n2zj58qicyz19mm0x6pmhb50jsics9";
    };
  });
  flake8 = super.flake8.overrideAttrs(oldDrv: rec {
    version = "3.7.8";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0j2526s738dbdsa1mp82s1yrlx0rrai3hi1y8xi9j6wpphf1q90r";
    };
  });
  flask = super.flask.overrideAttrs(oldDrv: rec {
    version = "1.0.2";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "2271c0070dbcb5275fad4a82e29f23ab92682dc45f9dfbc22c02ba9b9322ce48";
    };
  });
  funcsigs = super.funcsigs.overrideAttrs(oldDrv: rec {
    version = "1.0.2";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0l4g5818ffyfmfs1a924811azhjj8ax9xd1cffr1mzd3ycn0zfx7";
    };
  });
  future = super.future.overrideAttrs(oldDrv: rec {
    version = "0.16.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1nzy1k4m9966sikp0qka7lirh8sqrsyainyf8rk97db7nwdfv773";
    };
  });
  honcho = self.buildPythonPackage rec {
    pname = "honcho";
    version = "1.0.1";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0vpadk37y27m98x9lk151k96vp319w7jv8f6hdr7fdz3s8m412f1";
    };

    propagatedBuildInputs = [ self.jinja2 ];
  };
  idna = super.idna.overrideAttrs(oldDrv: rec {
    version = "2.7";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "05jam7d31767dr12x0rbvvs8lxnpb1mhdb2zdlfxgh83z6k3hjk8";
    };
  });
  ipdb = super.ipdb.overrideAttrs(oldDrv: rec {
    version = "0.11";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "02m0l8wrhhd3z7dg3czn5ys1g5pxib516hpshdzp7rxzsxgcd0bh";
    };
  });
  # ipython_genutils = self.buildPythonPackage rec {
  #   pname = "ipython_genutils";
  #   version = "0.2.0";

  #   src = self.fetchPypi {
  #     inherit pname version;
  #     sha256 = "1a4bc9y8hnvq6cp08qs4mckgm6i6ajpndp4g496rvvzcfmp12bpb";
  #   };

  #   checkInputs = [ self.nose ];
  # };
  isodate = super.isodate.overrideAttrs(oldDrv: rec {
    version = "0.6.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1n7jkz68kk5pwni540pr5zdh99bf6ywydk1p5pdrqisrawylldif";
    };
  });
  isort = super.isort.overrideAttrs(oldDrv: rec {
    version = "4.3.21";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1cfavhcvfy2sqdkpznc0xvhv15y91syqc36dxbyc8mc98s97xnjl";
    };
  });
  itsdangerous = super.itsdangerous.overrideAttrs(oldDrv: rec {
    version = "0.24";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "06856q6x675ly542ig0plbqcyab6ksfzijlyf1hzhgg3sgwgrcyb";
    };
  });
  jedi = super.jedi.overrideAttrs(oldDrv: rec {
    version = "0.17.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0c1h9x3a9klvk2g288wl328x8xgzw7136k6vs9hkd56b85vcjh6z";
    };

    propagatedBuildInputs = [ self.parso ];
  });
  jinja2 = super.jinja2.overrideAttrs(oldDrv: rec {
    version = "2.10.1";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "04shqrs56aj04ipyqykj512rw2l0zfammvj9krawzxz7xc14yp06";
    };
  });
  # jsonschema = super.jsonschema;

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
  jsonschema = self.buildPythonPackage rec {
    pname = "jsonschema";
    version = "3.0.1";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "03g20i1xfg4qdlk4475pl4pp7y0h37g1fbgs5qhy678q9xb822hc";
    };

    nativeBuildInputs = with self; [ setuptools_scm ];
    propagatedBuildInputs = with self; [ attrs importlib-metadata functools32 pyrsistent ];

    doCheck = false;
  };
  lazy-object-proxy = with self; buildPythonPackage rec {
    pname = "lazy-object-proxy";
    version = "1.3.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "eb91be369f945f10d3a49f5f9be8b3d0b93a4c2be8f8a5b83b0571b8123e0a7a";
    };

    buildInputs = [ pytest ];
    checkPhase = ''
      py.test tests
    '';

    # Broken tests. Seem to be fixed upstream according to Travis.
    doCheck = false;

    meta = with lib; {
      description = "A fast and thorough lazy object proxy";
      homepage = https://github.com/ionelmc/python-lazy-object-proxy;
      license = with licenses; [ bsd2 ];
    };

  };
  lz4 = super.lz4;
  markdown = super.markdown.overrideAttrs(oldDrv: rec {
    version = "2.6.11";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "108g80ryzykh8bj0i7jfp71510wrcixdi771lf2asyghgyf8cmm8";
    };
  });
  markupsafe = super.markupsafe.overrideAttrs(oldDrv: rec {
    version = "1.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0rdn1s8x9ni7ss8rfiacj7x1085lx8mh2zdwqslnw8xc3l4nkgm6";
    };
  });
  # mccabe = super.mccabe.overrideAttrs(oldDrv: rec {
  #   version = "0.6.1";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "07w3p1qm44hgxf3vvwz84kswpsx6s7kvaibzrsx5dzm0hli1i3fx";
  #   };
  # });
  more-itertools = super.more-itertools.overrideAttrs(oldDrv: rec {
    version = "4.2.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1s6qhl7a7jy8gqw8p545rxfp7rwz1hmjr9p6prk93zbv6f9rhsrb";
    };
  });
  packaging = super.packaging.overrideAttrs(oldDrv: rec {
    version = "17.1";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0nrpayk8kij1zm9sjnk38ldz3a6705ggvw8ljylqbrb4vmqbf6gh";
    };
  });
  parsimonious = super.parsimonious.overrideAttrs(oldDrv: rec {
    version = "0.8.1";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0swz38wl4dq5jw8ddzaqg1l9zzr7njhy8f8s7g5y106mja437p9s";
    };
  });
  parso = super.parso.overrideAttrs(oldDrv: rec {
    version = "0.7.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0b7irps2dqmzq41sxbpvxbivhh1x2hwmbqp45bbpd82446p9z3lh";
    };
  });
  pathtools = super.pathtools.overrideAttrs(oldDrv: rec {
    version = "0.1.2";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1h7iam33vwxk8bvslfj4qlsdprdnwf8bvzhqh3jq5frr391cadbw";
    };
  });
  pbr = super.pbr.overrideAttrs(oldDrv: rec {
    version = "4.0.4";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "039lsj50knlfin0sdda2cdadij99nznvlbabaip7hkp2y2w7xhm9";
    };
  });
  petname = self.buildPythonPackage rec {
    pname = "petname";
    version = "2.2";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1klsh7vqvh394vsq3diwfdbb4cx34yspjjws1s23j7m0d85aa7dy";
    };
  };
  pexpect = with self; buildPythonPackage rec {
    pname = "pexpect";
    version = "4.6.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "2a8e88259839571d1251d278476f3eec5db26deb73a70be5ed5dc5435e418aba";
    };

    # Wants to run python in a subprocess
    doCheck = false;

    propagatedBuildInputs = [ ptyprocess ];

    meta = with lib; {
      homepage = http://www.noah.org/wiki/Pexpect;
      description = "Automate interactive console applications such as ssh, ftp, etc";
      license = licenses.mit;
      maintainers = with maintainers; [ zimbatm ];

      longDescription = ''
        Pexpect is similar to the Don Libes "Expect" system, but Pexpect
        as a different interface that is easier to understand. Pexpect
        is basically a pattern matching system. It runs programs and
        watches output. When output matches a given pattern Pexpect can
        respond as if a human were typing responses. Pexpect can be used
        for automation, testing, and screen scraping. Pexpect can be
        used for automating interactive console applications such as
        ssh, ftp, passwd, telnet, etc. It can also be used to control
        web applications via "lynx", "w3m", or some other text-based web
        browser. Pexpect is pure Python. Unlike other Expect-like
        modules for Python Pexpect does not require TCL or Expect nor
        does it require C extensions to be compiled. It should work on
        any platform that supports the standard Python pty module.
      '';
    };
  };
  pluggy = super.pluggy.overrideAttrs(oldDrv: rec {
    version = "0.13.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0d4gsvb4kjqhiqqi4bbsdp7s1xlyl5phibcw1q1mrpd65xia2pzs";
    };
  });
  ptyprocess = super.ptyprocess.overrideAttrs(oldDrv: rec {
    version = "0.5.2";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0ra31k10v3629xq0kdn8lwmfbi97anmk48r03yvh7mks0kq96hg6";
    };
  });
  py = super.py.overrideAttrs(oldDrv: rec {
    version = "1.5.3";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "10gq2lckvgwlk9w6yzijhzkarx44hsaknd0ypa08wlnpjnsgmj99";
    };
  });
  pygments = super.pygments.overrideAttrs(oldDrv: rec {
    version = "2.2.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1k78qdvir1yb1c634nkv6rbga8wv4289xarghmsbbvzhvr311bnv";
    };
  });
  pylint = with self; buildPythonPackage rec {
    pname = "pylint";
    version = "2.3.1";

    disabled = pythonOlder "3.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1wgzq0da87m7708hrc9h4bc5m4z2p7379i4xyydszasmjns3sgkj";
    };

    nativeBuildInputs = [ pytestrunner ];

    checkInputs = [ pytest ];

    propagatedBuildInputs = [ astroid isort mccabe ];

    checkPhase = ''
      pytest pylint/test -k "not ${lib.concatStringsSep " and not " (
        # Broken tests
        [ "member_checks_py37" "iterable_context_py36" ]
      )}"
    '';

    postInstall = ''
      mkdir -p $out/share/emacs/site-lisp
      cp "elisp/"*.el $out/share/emacs/site-lisp/
    '';

    meta = with lib; {
      homepage = https://github.com/PyCQA/pylint;
      description = "A bug and style checker for Python";
      platforms = platforms.all;
      license = licenses.gpl1Plus;
      maintainers = with maintainers; [ nand0p ];
    };
  };
  pyparsing = with self; buildPythonPackage rec {
      pname = "pyparsing";
      version = "2.2.0";

      src = self.fetchPypi {
        inherit pname version;
        sha256 = "016b9gh606aa44sq92jslm89bg874ia0yyiyb643fa6dgbsbqch8";
      };

      # Not everything necessary to run the tests is included in the distribution
      doCheck = false;

      meta = with lib; {
        homepage = http://pyparsing.wikispaces.com/;
        description = "An alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions";
        license = licenses.mit;
      };
  };
  pytest = with self; buildPythonPackage rec {
    version = "5.1.0";
    pname = "pytest";

    disabled = !isPy3k;

    preCheck = ''
      # don't test bash builtins
      rm testing/test_argcomplete.py
    '';

    src = fetchPypi {
      inherit pname version;
      sha256 = "3805d095f1ea279b9870c3eeae5dddf8a81b10952c8835cd628cf1875b0ef031";
    };

    checkInputs = [ hypothesis mock ];
    nativeBuildInputs = [ setuptools_scm ];
    propagatedBuildInputs = [ attrs py setuptools six pluggy more-itertools atomicwrites wcwidth packaging ]
      ++ lib.optionals (pythonOlder "3.6") [ pathlib2 ];

    doCheck = !isPyPy; # https://github.com/pytest-dev/pytest/issues/3460

    # Ignored file https://github.com/pytest-dev/pytest/pull/5605#issuecomment-522243929
    checkPhase = ''
      runHook preCheck
      $out/bin/py.test -x testing/ -k "not test_collect_pyargs_with_testpaths" --ignore=testing/test_junitxml.py
      runHook postCheck
    '';

    # Remove .pytest_cache when using py.test in a Nix build
    setupHook = writeText "pytest-hook" ''
      pytestcachePhase() {
          find $out -name .pytest_cache -type d -exec rm -rf {} +
      }
      preDistPhases+=" pytestcachePhase"
    '';

    pythonImportsCheck = [
      "pytest"
    ];

    meta = with lib; {
      homepage = https://docs.pytest.org;
      description = "Framework for writing tests";
      maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
      license = licenses.mit;
    };
  };
  # pytest = super.pytest.overrideAttrs(oldDrv: rec {
  #   version = "5.2.4";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "1mm0j3w09dsnmjs4xpf6zmp7mmnrlv8smx6hhh1am6k6ky0r007z";
  #   };

  #   propagatedBuildInputs = with self; [ attrs py setuptools six pluggy more-itertools atomicwrites wcwidth packaging ];
  #   checkInputs = [ self.attrs ];
  # });
  pytest-cov = self.buildPythonPackage rec {
    pname = "pytest-cov";
    version = "2.5.1";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0bbfpwdh9k3636bxc88vz9fa7vf4akchgn513ql1vd0xy4n7bah3";
    };

    propagatedBuildInputs = [ self.coverage self.pytest ];
  };
  pytest-forked = super.pytest-forked.overrideAttrs(oldDrv: rec {
    version = "1.1.3";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "000i4q7my2fq4l49n8idx2c812dql97qv6qpm2vhrrn9v6g6j18q";
    };
  });
  pytest-watch = super.pytest-watch.overrideAttrs(oldDrv: rec {
    version = "4.2.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1fflnd3varpqy8yzcs451n8h7wmjyx1408qdin5p2qdksl1ny4q6";
    };
  });
  pytest-xdist = self.buildPythonPackage rec {
    pname = "pytest-xdist";
    version = "1.30.0";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0j6gmhlp6mcs8l42fgpj6xsny3b7cgxn5avdslin12jic521s6sx";
    };

    propagatedBuildInputs = [ self.setuptools_scm self.execnet self.pytest-forked self.six self.pytest ];
  };
  python-dateutil = super.python-dateutil.overrideAttrs(oldDrv: rec {
    version = "2.7.3";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1f7h54lg0w2ckch7592xpjkh8dg87k2br256h0iw49zn6bg02w72";
    };
  });
  python-rapidjson = super.python-rapidjson.overrideAttrs(oldDrv: rec {
    version = "0.8.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "13fgy5bqslx913p9gachj9djk3g6wx1igwaccfnxjl2msrbwclwp";
    };
  });
  redis = with self; buildPythonPackage rec {
    pname = "redis";
    version = "2.10.6";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "03vcgklykny0g0wpvqmy8p6azi2s078317wgb2xjv5m2rs9sjb52";
    };

    # tests require a running redis
    doCheck = false;

    meta = with lib; {
      description = "Python client for Redis key-value store";
      homepage = "https://pypi.python.org/pypi/redis/";
      license = with licenses; [ mit ];
    };
  };
  redis-py-cluster = self.buildPythonPackage rec {
    pname = "redis-py-cluster";
    version = "1.3.6";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "0b749rbmscy30an610kdanpazjbzy09b2xk6h2ilvlqbwqflpdbx";
    };

    propagatedBuildInputs = [ self.redis ];
  };
  semaphore = self.callPackage ../sentry/semaphore { };

  rq = self.buildPythonPackage rec {
    pname = "rq";
    version = "0.12.0";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "16d8kni57xlnah2hawy4xgw21xrv3f64j5q5shyp3zxx4yd9iibs";
    };

    # test require a running redis rerver, which is something we can't do yet
    doCheck = false;

    propagatedBuildInputs = with self; [ click redis ];

    meta = with lib; {
      description = "A simple, lightweight library for creating background jobs, and processing them";
      homepage = "https://github.com/nvie/rq/";
      maintainers = with maintainers; [ mrmebelman ];
      license = licenses.bsd2;
    };
  };

  sentry-sdk = self.buildPythonPackage rec {
    pname = "sentry-sdk";
    version = "0.13.5";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "c6b919623e488134a728f16326c6f0bcdab7e3f59e7f4c472a90eea4d6d8fe82";
    };

    checkInputs = with self; [ django flask tornado bottle rq falcon sqlalchemy ]
    ++ lib.optionals isPy3k [ celery pyramid sanic aiohttp ];

    propagatedBuildInputs = with self; [ urllib3 certifi ];

    meta = with lib; {
      homepage = "https://github.com/getsentry/sentry-python";
      description = "New Python SDK for Sentry.io";
      license = licenses.bsd2;
      maintainers = with maintainers; [ gebner ];
    };

    # The Sentry tests need access to `/etc/protocols` (the tests call
    # `socket.getprotobyname('tcp')`, which reads from this file). Normally
    # this path isn't available in the sandbox. Therefore, use libredirect
    # to make on eavailable from `iana-etc`. This is a test-only operation.
    preCheck = ''
      export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols
      export LD_PRELOAD=${libredirect}/lib/libredirect.so
    '';
    postCheck = "unset NIX_REDIRECTS LD_PRELOAD";
  };

  # simplegeneric = super.simplegeneric.overrideAttrs(oldDrv: rec {
  #   version = "0.8.1";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     extension = "zip";
  #     sha256 = "0wwi1c6md4vkbcsfsf8dklf3vr4mcdj4mpxkanwgb6jb1432x5yw";
  #   };
  # });
  simplejson = super.simplejson.overrideAttrs(oldDrv: rec {
    version = "3.15.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1yvk6knpqmqd34012s1qfnyf84px9wznh2id2gyfy72mv5jjycxd";
    };
  });
  singledispatch = super.singledispatch.overrideAttrs(oldDrv: rec {
    version = "3.4.0.3";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "171b7ip0hsq5qm83np40h3phlr36ym18w0lay0a8v08kvy3sy1jv";
    };
  });
  traceback2 = super.traceback2.overrideAttrs(oldDrv: rec {
    version = "1.4.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0c1h3jas1jp1fdbn9z2mrgn3jj0hw1x3yhnkxp7jw34q15xcdb05";
    };
  });
  traitlets = with self; buildPythonPackage rec {
    pname = "traitlets";
    version = "4.3.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "9c4bd2d267b7153df9152698efb1050a5d84982d3384a37b2c1f7723ba3e7835";
    };

    checkInputs = [ glibcLocales pytest mock ];
    propagatedBuildInputs = [ ipython_genutils decorator six ] ++ lib.optional (pythonOlder "3.4") enum34;

    checkPhase = ''
      LC_ALL="en_US.UTF-8" py.test
    '';

    meta = {
      description = "Traitlets Python config system";
      homepage = http://ipython.org/;
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ fridh ];
    };
  };
  typing-extensions = super.typing-extensions.overrideAttrs(oldDrv: rec {
    version = "3.7.4.1";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1wj1vcgbnm20aiinmphyxfrbv3qi9xdhvw89ab3qm42y9n4wq7h9";
    };
  });
  unittest2 = super.unittest2.overrideAttrs(oldDrv: rec {
    version = "1.1.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0y855kmx7a8rnf81d3lh5lyxai1908xjp0laf4glwa4c8472m212";
    };
  });
  urllib3 = super.urllib3.overrideAttrs(oldDrv: rec {
    version = "1.25.3";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0cij8qcvvpj62g1q8n785qjkdymfh4b7vf45si4sw64l41rr3rfv";
    };
  });
  uwsgi = self.buildPythonPackage rec {
    pname = "uwsgi";
    version = "2.0.17";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1wlbaairsmhp6bx5wv282q9pgh6w7w6yrb8vxjznfaxrinsfkhix";
    };

    buildInputs = [ ncurses ];

    doCheck = false;
  };
  # wcwidth = super.wcwidth.overrideAttrs(oldDrv: rec {
  #   version = "0.1.7";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "0pn6dflzm609m4r3i8ik5ni9ijjbb5fa3vg1n7hn6vkd49r77wrx";
  #   };
  # });
  # werkzeug = super.werkzeug.overrideAttrs(oldDrv: rec {
  #   version = "0.15.3";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "cfd1281b1748288e59762c0e174d64d8bcb2b70e7c57bc4a1203c8825af24ac3";
  #   };
  # });
  werkseug = super.werkzeug;
  wrapt = with self; buildPythonPackage rec {
    pname = "wrapt";
    version = "1.10.11";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "1ip3dwib39xhp79kblskgvz3fjzcwxgx3fs3ahdixhpjg7a61mfl";
    };

    # No tests in archive
    doCheck = false;

    meta = {
      description = "Module for decorators, wrappers and monkey patching";
      license = lib.licenses.bsd2;
      homepage = https://github.com/GrahamDumpleton/wrapt;
    };
  };
  milksnake = super.milksnake;

  hypothesis = with self; buildPythonPackage rec {
    # https://hypothesis.readthedocs.org/en/latest/packaging.html

    # Hypothesis has optional dependencies on the following libraries
    # pytz fake_factory django numpy pytest
    # If you need these, you can just add them to your environment.

    version = "4.7.3";
    pname = "hypothesis";

    # Use github tarballs that includes tests
    src = fetchFromGitHub {
      owner = "HypothesisWorks";
      repo = "hypothesis-python";
      rev = "hypothesis-python-${version}";
      sha256 = "03l4hp0p7i2k04arnqkav0ygc23ml46dy3cfrlwviasrj7yzk5hc";
    };

    postUnpack = "sourceRoot=$sourceRoot/hypothesis-python";

    propagatedBuildInputs = [ attrs coverage ] ++ lib.optional (!isPy3k) [ enum34 ];

    checkInputs = [ pytest pytest_xdist flaky mock ];
    doCheck = false;

    checkPhase = ''
      rm tox.ini # This file changes how py.test runs and breaks it
      py.test tests/cover
    '';

    meta = with lib; {
      description = "A Python library for property based testing";
      homepage = https://github.com/HypothesisWorks/hypothesis;
      license = licenses.mpl20;
    };
  };

  sanic = with self; buildPythonPackage rec {
    pname = "sanic";
    version = "19.3.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "ce434eb154872ca64493a6c3a288f11fd10bca0de7be7bf9f1d0d063185e51ec";
    };

    propagatedBuildInputs = [
      httptools
      aiofiles
      websockets
      multidict
      uvloop
      ujson
    ];

    checkInputs = [
      pytest
      gunicorn
      pytestcov
      aiohttp
      beautifulsoup4
      pytest-sanic
      pytest-sugar
      pytest-benchmark
    ];

    postConfigure = ''
      substituteInPlace setup.py \
        --replace "websockets>=6.0,<7.0" "websockets"
    '';

    # 10/500 tests ignored due to missing directory and
    # requiring network access
    checkPhase = ''
      pytest --ignore tests/test_blueprints.py \
             --ignore tests/test_routes.py \
             --ignore tests/test_worker.py
    '';

    meta = with lib; {
      description = "A microframework based on uvloop, httptools, and learnings of flask";
      homepage = http://github.com/channelcat/sanic/;
      license = licenses.mit;
      maintainers = [ maintainers.costrouc ];
    };
  };
}
