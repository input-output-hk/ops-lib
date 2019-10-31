{ lib, region, accessKeyId, nodes }:
let
  inherit (lib) foldl' recursiveUpdate mapAttrs' nameValuePair flip;
in flip mapAttrs' nodes (name: node:
  nameValuePair "allow-graylog-${name}-${region}" ({resources, ...}: {
    inherit region accessKeyId;
    _file = ./allow-graylog.nix;
    description = "Allow Graylog ${name} ${region}";
    rules = [{
      protocol = "tcp"; # all
      fromPort = 5044;
      toPort = 5044;
      sourceIp = resources.elasticIPs."${name}-ip";
    }];
  })
)
