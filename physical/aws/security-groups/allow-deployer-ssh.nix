{ region, accessKeyId, ... }: {
  "allow-deployer-ssh-${region}" = {
    inherit region accessKeyId;
    _file = ./allow-deployer-ssh.nix;
    description = "SSH";
    rules = [{
      protocol = "tcp"; # TCP
      fromPort = 22;
      toPort = 22;
      sourceIp = "0.0.0.0/0"; # TODO: fixme
    }];
  };
}
