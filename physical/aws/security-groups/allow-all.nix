{ region, org, lib, pkgs, ... }@args: {
  "allow-all-${region}-${org}" = {resources, ...}: {
    inherit region;
    accessKeyId = pkgs.globals.ec2.credentials.accessKeyIds.${org};
    _file = ./allow-all.nix;
    description = "Allow all ${region}";
    rules = [{
      protocol = "-1"; # all
      fromPort = 0;
      toPort = 65535;
      sourceIp = "0.0.0.0/0";
      sourceIpv6 = "::/0";
    }];
  } // pkgs.lib.optionalAttrs (args ? vpcId) {
    vpcId = resources.vpc.${args.vpcId};
  };
}
