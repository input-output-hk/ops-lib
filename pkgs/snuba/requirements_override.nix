{ pkgs, python }:

let
  lib = pkgs.lib;
  fetchPypi = pkgs.python.pkgs.fetchPypi;
in

self: super: {
  "pytest-runner" = python.mkDerivation {
    name = "pytest-runner-5.1";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/d9/6d/4b41a74b31720e25abd4799be72d54811da4b4d0233e38b75864dcc1f7ad/pytest-runner-5.1.tar.gz";
      sha256 = "25a013c8d84f0ca60bb01bd11913a3bcab420f601f0f236de4423074af656e7a";
    };
    doCheck = false;
    buildInputs = [
      self."setuptools-scm"
    ];
    propagatedBuildInputs = [ ];
    meta = with lib; {
      homepage = "https://github.com/pytest-dev/pytest-runner/";
      license = "UNKNOWN";
      description = "Invoke py.test as distutils command with dependency resolution";
    };
  };

  "jedi" = python.overrideDerivation super."jedi" (old: rec {
    pname = "jedi";
    version = "0.15.2";
    
    src = fetchPypi {
      inherit pname version;
      sha256 = "e909527104a903606dd63bea6e8e888833f0ef087057829b89a18364a856f807";
    };
    
    postPatch = ''
      substituteInPlace requirements.txt --replace "parso==0.1.0" "parso"
    '';
      
    propagatedBuildInputs = with self; [ parso ];
    
    checkPhase = ''
      LC_ALL="en_US.UTF-8" py.test test
    '';
    
    # tox required for tests: https://github.com/davidhalter/jedi/issues/808
    doCheck = false;
    
    meta = with lib; {
      homepage = "https://github.com/davidhalter/jedi";
      description = "An autocompletion tool for Python that can be used for text editors";
      license = licenses.lgpl3Plus;
      maintainers = with maintainers; [ ];
    };
  });

  "linecache2" = python.overrideDerivation super."linecache2" (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ self.pbr ];
  });

  "lz4" = python.overrideDerivation super."lz4" (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ self."pytest-runner" self."pkgconfig" self."setuptools-scm" ];
  });

  "python-dateutil" = python.overrideDerivation super."python-dateutil" (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ self."setuptools-scm" ];
  });

  "unittest2" = python.overrideDerivation super."unittest2" (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ self."argparse" ];
  });

  "flake8" = python.overrideDerivation super."flake8" (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ self."argparse" ];
  });

  "pylint" = python.overrideDerivation super."pylint" (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ self."pytest-runner" ];
  });

  pkgconfig = pkgs.python37.pkgs.pkgconfig;

  uwsgi = python.mkDerivation rec {
    pname = "uwsgi";
    version = "2.0.17";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1wlbaairsmhp6bx5wv282q9pgh6w7w6yrb8vxjznfaxrinsfkhix";
    };

    buildInputs = [ pkgs.ncurses ];

    doCheck = false;
  };

  pytest-xdist = python.mkDerivation rec {
    pname = "pytest-xdist";
    version = "1.30.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0j6gmhlp6mcs8l42fgpj6xsny3b7cgxn5avdslin12jic521s6sx";
    };

    buildInputs = [];

    propagatedBuildInputs = with self; [ setuptools-scm execnet pytest-forked six pytest ];
  };

  pytest-forked = python.mkDerivation rec {
    pname = "pytest-forked";
    version = "1.1.3";
  
    src = fetchPypi {
      inherit pname version;
      sha256 = "1805699ed9c9e60cb7a8179b8d4fa2b8898098e82d229b0825d8095f0f261100";
    };
  
    buildInputs = with self; [ pytest setuptools-scm ];
  
    # Do not function
    doCheck = false;
  
    meta = {
      description = "Run tests in isolated forked subprocesses";
      homepage = "https://github.com/pytest-dev/pytest-forked";
      license = lib.licenses.mit;
    };
  };

  semaphore = pkgs.python37.pkgs.callPackage ../sentry/semaphore { };
}
