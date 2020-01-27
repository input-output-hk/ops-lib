portName: port: { region, org, pkgs, ... }: {
  "allow-all-to-${portName}-${region}-${org}" = {
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
  };
}
