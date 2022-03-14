{ lib, region, org, nodes, pkgs, ... }@args:
import ./allow-to-tcp-port.nix "graylog" 5044 (lib.attrNames nodes) args
