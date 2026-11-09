self: super:
let
  nixopsSrc = self.applyPatches {
    name = "nixops-src-patched";
    src = self.sourcePaths.nixops-core;
    patches = [ ../nix/patches/nixops-nixos-26.05.patch ];
  };
in {
  nixops = (import (nixopsSrc + "/release.nix") {
    nixpkgs = self.applyPatches {
      name = "nixpkgs-nixops-patched";
      src = self.sourcePaths.nixpkgs-nixops;
      patches = [ ../nix/patches/nixops-urllib3.patch ];
    };
    pluginsSources = self.sourcePaths;
    p = self.lib.attrVals (self.globals.nixops-plugins or [ "nixops-aws" "nixops-libvirtd" ]);
  }).build.${self.stdenv.system};
}
