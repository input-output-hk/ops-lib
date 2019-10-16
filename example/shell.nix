with import ../nix {};
mkShell {
  buildInputs = [ niv nixops nix which ];
}
