{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
, sourcesOverride ? {}
, pkgs ? import ./nix { inherit system crossSystem config sourcesOverride; } }:
with pkgs; {
  inherit nixops nginxStable nginxMainline;
  overlays = import ./overlays sourcePaths;
  shell = mkShell {
    buildInputs = [ niv nixops nix telnet dnsutils ];
    NIX_PATH = "nixpkgs=${path}";
    NIXOPS_DEPLOYMENT = "${globals.deploymentName}";
  };
}
