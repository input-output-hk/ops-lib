{ sources ? import ./nix/sources.nix
, system ? builtins.currentSystem
, crossSystem ? null
, config ? {}}@args
: with import ./nix args; {
  inherit overlays nixops;
  shell = import ./shell.nix;
}
