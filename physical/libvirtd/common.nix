{ pkgs, name, ... }:
let inherit (pkgs.globals) domain;
in {
  deployment.libvirtd.headless = false;
  nixpkgs.localSystem.system = "x86_64-linux";
  imports = [ ../../modules/aws.nix ];
  node = { fqdn = "${name}.${domain}"; };
}
