{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
, sourcesOverride ? {}
, pkgs ? import ./nix { inherit system crossSystem config sourcesOverride; } }:

let
  makeZfsImage = { module, type, system, ... }:
    pkgs.lib.hydraJob ((import ("${pkgs.path}/nixos/lib/eval-config.nix") {
      inherit system;
      modules = [ module ];
    }).config.system.build.zfsImage);
in
with pkgs; {
  inherit nixops nginxStable nginxMainline;
  overlays = import ./overlays sourcePaths;
  shell = mkShell {
    buildInputs = [ niv nixops nix telnet dnsutils ];
    NIX_PATH = "nixpkgs=${path}";
    NIXOPS_DEPLOYMENT = "${globals.deploymentName}";
  };
  zfs-image = makeZfsImage {
    module = ./zfs/make-zfs-image.nix;
    type = "zfs";
    inherit system;
  };
}
