{ region, org, pkgs, ... }@args: {
  "allow-public-www-https-${region}-${org}" = {resources, ...}: {
    _file = ./allow-public-www-https.nix;
    inherit region;
    accessKeyId = pkgs.globals.ec2.credentials.accessKeyIds.${org};
    description = "WWW-http(s)";
    rules = [
      {
        protocol = "tcp";
        fromPort = 80;
        toPort = 80;
        sourceIp = "0.0.0.0/0";
        sourceIpv6 = "::/0";
      }
      {
        protocol = "tcp";
        fromPort = 443;
        toPort = 443;
        sourceIp = "0.0.0.0/0";
        sourceIpv6 = "::/0";
      }
    ];
  } // pkgs.lib.optionalAttrs (args ? vpcId) {
    vpcId = resources.vpc.${args.vpcId};
  };
}
