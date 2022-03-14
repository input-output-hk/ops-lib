portName: port: sourcesNodes: { region, org, pkgs, ... }@args: {
  "allow-to-${portName}-${region}-${org}" = { resources, ... }: {
    inherit region;
    accessKeyId = pkgs.globals.ec2.credentials.accessKeyIds.${org};
    _file = ./allow-to-tcp-port.nix;
    description = "Allow to TCP/${toString port}";
    rules = map (n: {
      protocol = "tcp"; # all
      fromPort = port;
      toPort = port;
      sourceIp = resources.elasticIPs."${n}-ip";
    }) sourcesNodes;
  } // pkgs.lib.optionalAttrs (args ? vpcId) {
    inherit (args) vpcId;
  };
}
