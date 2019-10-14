self: super: {
  nixops = (import (self.sources.nixops-core + "/release.nix") {
    nixpkgs = self.path;
    p = p:
      let
        pluginSources = with self.sources; [ nixops-packet nixops-libvirtd ];
        plugins = map (source: p.callPackage (source + "/release.nix") { })
          pluginSources;
      in [ p.aws ] ++ plugins;
  }).build.${self.stdenv.system};
}
