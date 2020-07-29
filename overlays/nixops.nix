self: super: with self; {
  nixops-aws = (import sourcePaths.nixops { inherit pkgs; }).withPlugins
        (ps: [ (ps.callPackage sourcePaths.nixops-aws { inherit pkgs; }) ]);

  nixops = (import (sourcePaths.nixops-core + "/release.nix") {
    nixpkgs = path;
    p = p:
      let
        pluginSources = with sourcePaths; [ nixops-packet nixops-libvirtd ];
        plugins = map (source: p.callPackage (source + "/release.nix") { })
          pluginSources;
      in [ p.aws ] ++ plugins;
  }).build.${self.stdenv.system};
}
