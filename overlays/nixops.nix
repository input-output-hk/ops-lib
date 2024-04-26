self: super: {
  nixops = (import (self.sourcePaths.nixops-core + "/release.nix") {
    nixpkgs = self.sourcePaths.nixpkgs-nixops;
    pluginsSources = self.sourcePaths;
    p = self.lib.attrVals (self.globals.nixops-plugins or [ "nixops-aws" "nixops-libvirtd" ]);
  }).build.${self.stdenv.system};
}
