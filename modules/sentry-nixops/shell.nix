{
  pkgs ? import ./nix {}
}:
with pkgs;                                                                                                                                                                                                        

mkShell {
  buildInputs = [ iohkNix.niv nixops nix ];
  NIX_PATH = "nixpkgs=${path}";
  NIXOPS_DEPLOYMENT = "sentry";
}


