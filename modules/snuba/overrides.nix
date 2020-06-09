{ pkgs }:

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
  astroid = super.astroid;
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
  # clickhouse_driver = self.buildPythonPackage rec {
  #   pname = "clickhouse-driver";
  #   version = "0.1.1";

  #   src = self.fetchPypi {
  #     inherit pname version;
  #     sha256 = "3eeb6d2683b38755dcccef117b1361356b5e29619766f9463c68fe10f5e72cf1";
  #   };

  #   propagatedBuildInputs = [ self.pytz self.clickhouse_cityhash self.zstd ];
  # };
  # clickhouse_cityhash = self.buildPythonPackage rec {
  #   pname = "clickhouse-cityhash";
  #   version = "1.0.2.3";

  #   src = self.fetchPypi {
  #     inherit pname version;
  #     sha256 = "2f377d20796c6fe4bc1c5b4e07082782788401f14677febc35305ce129a0167d";
  #   };
  # };
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
  decorator = super.decorator.overrideAttrs(oldDrv: rec {
    version = "4.3.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "0308djallnh00v112y5b7nadl657ysmkp6vc8xn51d6yzc9zm7n3";
    };
  });
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
  # flake8 = super.flake8.overrideAttrs(oldDrv: rec {
  #   version = "3.7.8";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "0j2526s738dbdsa1mp82s1yrlx0rrai3hi1y8xi9j6wpphf1q90r";
  #   };
  # });
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
  # lazy-object-proxy = super.lazy-object-proxy.overrideAttrs(oldDrv: rec {
  #   version = "1.3.1";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "0yha7q9bhw857fwaby785d63mffhngl9npwzlk9i0pwlkwvbx4gb";
  #   };
  # });
  # linecache2 = super.linecache2.overrideAttrs(oldDrv: rec {
  #   version = "1.0.0";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "0z79g3ds5wk2lvnqw0y2jpakjf32h95bd9zmnvp7dnqhf57gy9jb";
  #   };
  # });
  # lz4 = self.buildPythonPackage rec {
  #   pname = "lz4";
  #   version = "2.0.0";

  #   src = self.fetchPypi {
  #     inherit pname version;
  #     sha256 = "0gmbyh37ssx5qzvz3hd455f13jbfcf15vr25h29gf7d5a29fh78m";
  #   };

  #   nativeBuildInputs = [ self.pytestrunner ];
  #   propagatedBuildInputes = [ self.pytestrunner ];
  #   checkInputs = [ self.pytestrunner self.pkgconfig self.setuptools_scm self.psutil self.pytest ];

  #   doCheck = false;
  # };
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
  # more-itertools = super.more-itertools.overrideAttrs(oldDrv: rec {
  #   version = "4.2.0";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "1s6qhl7a7jy8gqw8p545rxfp7rwz1hmjr9p6prk93zbv6f9rhsrb";
  #   };
  # });
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
  # pexpect = super.pexpect.overrideAttrs(oldDrv: rec {
  #   version = "4.6.0";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "1fla85g47iaxxpjhp9vkxdnv4pgc7rplfy6ja491smrrk0jqi3ia";
  #   };
  # });
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
  pylint = super.pylint;
  # pylint = super.pylint.overrideAttrs(oldDrv: rec {
  #   version = "2.4.1";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "0d04x5bbm69zym5illg0q9rmnp7lc5p8j706k2n25blgxr5s541c";
  #   };
  # });
  pyparsing = super.pyparsing.overrideAttrs(oldDrv: rec {
    version = "2.2.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "016b9gh606aa44sq92jslm89bg874ia0yyiyb643fa6dgbsbqch8";
    };
  });
  pytest = super.pytest;
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
  # python-dateutil = super.python-dateutil.overrideAttrs(oldDrv: rec {
  #   version = "2.7.3";

  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "1f7h54lg0w2ckch7592xpjkh8dg87k2br256h0iw49zn6bg02w72";
  #   };
  # });
  python-rapidjson = super.python-rapidjson.overrideAttrs(oldDrv: rec {
    version = "0.8.0";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "13fgy5bqslx913p9gachj9djk3g6wx1igwaccfnxjl2msrbwclwp";
    };
  });
  # redis = super.redis;
  redis = super.redis.overrideAttrs(oldDrv: rec {
    version = "3.0.1";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1kw3a1618pl908abiaxd41jg5z0rwyl2w2i0d8xi9zxy5437a011";
    };
  });
  redis-py-cluster = self.buildPythonPackage rec {
    pname = "redis-py-cluster";
    version = "2.0.0";

    src = self.fetchPypi {
      inherit pname version;
      sha256 = "18yrs2snr9khfzavj6acjdjidkqnw0a3xlri1nj85w1gxm5iai0s";
    };

    propagatedBuildInputs = [ self.redis ];
  };
  semaphore = self.callPackage ../sentry/semaphore { };
  sentry-sdk = super.sentry-sdk.overrideAttrs(oldDrv: rec {
    version = "0.13.5";

    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "10pyv3ba9vlh593lqzwyypivgnmwy332cqzi52kk90a87ri1kff6";
    };
  });
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
  # traitlets = super.traitlets.overrideAttrs(oldDrv: rec {
  #   version = "4.3.2";
  
  #   src = self.fetchPypi {
  #     inherit (oldDrv) pname;
  #     inherit version;
  #     sha256 = "0dbq7sx26xqz5ixs711k5nc88p8a0nqyz6162pwks5dpcz9d4jww";
  #   };
  # });
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

    buildInputs = [ pkgs.ncurses ];

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
  wrapt = super.wrapt.overrideAttrs(oldDrv: rec {
    version = "1.10.11";
  
    src = self.fetchPypi {
      inherit (oldDrv) pname;
      inherit version;
      sha256 = "1ip3dwib39xhp79kblskgvz3fjzcwxgx3fs3ahdixhpjg7a61mfl";
    };
  });
}
