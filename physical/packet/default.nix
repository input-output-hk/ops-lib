{ pkgs, lib, name, config, resources, ... }:
let inherit (pkgs.globals) domain packet;
in {
  deployment.packet = {
    keyPair = resources.packetKeyPairs.global;
    inherit (packet.credentials) accessKeyId project;
  };

  nixpkgs.localSystem.system = "x86_64-linux";

  node = { fqdn = "${name}.${domain}"; };
}
