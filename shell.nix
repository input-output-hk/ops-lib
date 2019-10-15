with import ./nix {};
mkShell {
  buildInputs = [ niv ];
}
