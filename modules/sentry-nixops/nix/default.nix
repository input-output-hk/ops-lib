{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
}:
let
  sourcePaths = import ./sources.nix { inherit pkgs; };

  # use our own nixpkgs if it exists in our sources,
  # otherwise use iohkNix default nixpkgs.
  nixpkgs = if (sourcePaths ? nixpkgs)
    then sourcePaths.nixpkgs
    else (import sourcePaths.iohk-nix {}).nixpkgs;

  iohkNix = import sourcePaths.iohk-nix {};

  # overlays from ops-lib (include ops-lib sourcePaths):
  ops-lib-overlays = (import sourcePaths.ops-lib {}).overlays;

  nixops-overlay = self: super: {
    nixops = (import (self.sourcePaths.nixops-core + "/release.nix") {
      nixpkgs = self.path;
      p = p:
        let
          pluginSources = with self.sourcePaths; [ nixops-libvirtd ];
          plugins = map (source: p.callPackage (source + "/release.nix") { })
            pluginSources;
        in [ p.aws p.vbox ] ++ plugins;
    }).build.${self.stdenv.system};
  };

  overlays = [
    (self: super: { iohkNix = import sourcePaths.iohk-nix {}; })
  ];

  pkgs = import nixpkgs {
    inherit system crossSystem config overlays;
  };
in
  pkgs

