{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
, sourcesOverride ? {}
, pkgs ? import ./nix { inherit system crossSystem config sourcesOverride; }
, withRustOverlays ? false
}:
with pkgs; {
  inherit nixops nginxStable nginxMainline;
  overlays = import ./overlays sourcePaths withRustOverlays;
  shell = mkShell {
    buildInputs = [ niv nixops nix dnsutils ];
    NIX_PATH = "nixpkgs=${path}";
    NIXOPS_DEPLOYMENT = "${globals.deploymentName}";
  };
}
