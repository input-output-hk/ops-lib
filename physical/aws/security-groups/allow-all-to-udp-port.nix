portName: port: { region, org, pkgs, ... }@args: {
  "allow-all-to-${portName}-${region}-${org}" = {resources, ...}: {
    inherit region;
    accessKeyId = pkgs.globals.ec2.credentials.accessKeyIds.${org};
    _file = ./allow-all-to-udp-port.nix;
    description = "Allow All to UDP/${toString port}";
    rules = [{
      protocol = "udp";
      fromPort = port;
      toPort = port;
      sourceIp = "0.0.0.0/0";
    }];
  } // pkgs.lib.optionalAttrs (args ? vpcId) {
    resources.vpc.vpcId = args.vpcId;
  };
}
