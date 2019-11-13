{ lib, region, org, nodes, pkgs, ... }:
import ./allow-to-tcp-port.nix "graylog" 5044 (lib.attrNames nodes) {
  inherit region org pkgs;
}
