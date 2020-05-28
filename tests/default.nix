{ pkgs ? import ../nix {}
, supportedSystems ? [ "x86_64-linux" ]
}:

with pkgs;
# with pkgs.commonLib;

 let
  importTest = fn: args: system: let
    imported = import fn;
    test = import (pkgs.path + "/nixos/tests/make-test.nix") imported;
  in test ({
    inherit pkgs system config;
  } // args);
  callTest = fn: args: (importTest fn args system);

in rec {
  sentry = callTest ./sentry.nix {};
}
