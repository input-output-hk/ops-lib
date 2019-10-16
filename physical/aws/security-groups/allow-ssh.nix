{ region, accessKeyId, ... }: {
  "allow-ssh-${region}" = {
    inherit region accessKeyId;
    _file = ./allow-ssh.nix;
    description = "Allow SSH ${region}";
    rules = [{
      protocol = "tcp"; # all
      fromPort = 22;
      toPort = 22;
      sourceIp = "0.0.0.0/0";
    }];
  };
}
