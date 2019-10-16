{ pkgs, lib, name, config, resources, ... }:
let inherit (import ../../globals.nix) domain packet;
in {
  deployment.packet = {
    keyPair = resources.packetKeyPairs.global;
    inherit (packet.credentials) accessKeyId project;
  };

  nixpkgs.localSystem.system = "x86_64-linux";

  node = { fqdn = "${name}.${domain}"; };
}
