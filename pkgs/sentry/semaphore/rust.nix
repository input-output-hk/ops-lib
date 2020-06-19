{ naersk
, fetchFromGitHub
, pkg-config
, openssl
}:

let
 sources = import ./source.nix { inherit fetchFromGitHub; };
in

naersk.buildPackage rec {
  pname = "semaphore";
  version = "0.4.65";

  src =
    sources.semaphore.overrideAttrs(drv: {
      postFetch = drv.postFetch + ''
        # See commentary in patch
        patch --directory=$out --strip=1 < ${./semaphore.patch}

        # Copy over the json-forensics crate
        cp -r ${sources.json-forensics} $out/json-forensics
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
