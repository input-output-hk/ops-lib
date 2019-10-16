{ sources ? import ./nix/sources.nix
, system ? builtins.currentSystem
, crossSystem ? null
, config ? {}}@args
: with import ./nix args; {
  shell = mkShell {
    buildInputs = [ niv nixops ];
  };
}
