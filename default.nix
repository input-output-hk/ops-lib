args: with import ./nix args; {
  inherit nixops nginxStable nginxMainline;
  overlays = import ./overlays sources;
  shell = mkShell {
    buildInputs = [ niv ];
  };
}
