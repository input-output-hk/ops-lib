{ region, accessKeyId, ... }: {
  "allow-all-${region}" = {
    inherit region accessKeyId;
    _file = ./allow-all.nix;
    description = "Allow all ${region}";
    rules = [{
      protocol = "-1"; # all
      fromPort = 0;
      toPort = 65535;
      sourceIp = "0.0.0.0/0";
    }];
  };
}
