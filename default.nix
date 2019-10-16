{ sources ? import ./nix/sources.nix
, system ? builtins.currentSystem
, crossSystem ? null
, config ? {} }@args: with import ./nix args; {
  inherit nixops nginxStable nginxMainline;
  overlays = import ./overlays sources;
  shell = mkShell {
    buildInputs = [ niv ];
  };
}
