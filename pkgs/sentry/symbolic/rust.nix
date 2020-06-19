{ naersk
, fetchFromGitHub
, pkg-config
, openssl
}:

let
 sources = import ./source.nix { inherit fetchFromGitHub; };
in

naersk.buildPackage rec {
  pname = "symbolic";
  version = "7.2.0";

  src =
    sources.symbolic.overrideAttrs(drv: {
      postFetch = drv.postFetch + ''
        # See commentary in patch
        patch --directory=$out --strip=1 < ${./rust.patch}

        cp ${./Cargo.lock} $out/Cargo.lock

        # Copy over apple-crash-report-parser crate
        cp -r ${sources.apple-crash-report-parser} $out/apple-crash-report-parser
      '';
    });

  override = (drv: {
    preConfigure = ''
      # Kinda hacky, but this works to build the cabi dylib with all
      # the dependencies from the root project.
      cd cabi
    '';

    postInstall = ''
      cp -r ${src}/cabi/include $out/include
    '';
  });

  nativeBuildInputs = [ pkg-config openssl ];
}
