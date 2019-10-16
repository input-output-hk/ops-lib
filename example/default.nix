args: with import ./nix args; {
  shell = mkShell {
    buildInputs = [ niv nixops nix ];
  };
}
