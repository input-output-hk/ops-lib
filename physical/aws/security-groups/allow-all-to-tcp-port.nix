portName: port: { region, org, pkgs, ... }: {
  "allow-all-to-${portName}-${region}-${org}" = {
    inherit region;
    accessKeyId = pkgs.globals.ec2.credentials.accessKeyIds.${org};
    _file = ./allow-all-to-tcp-port.nix;
    description = "Allow All to TCP/${toString port}";
    rules = [{
      protocol = "tcp";
      fromPort = port;
      toPort = port;
      sourceIp = "0.0.0.0/0";
    }];
  };
}
