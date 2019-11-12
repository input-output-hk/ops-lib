{ region, accessKeyId, ... }: {
  "allow-deployer-ssh-${region}" = { pkgs, ...}: {
    inherit region accessKeyId;
    _file = ./allow-deployer-ssh.nix;
    description = "SSH";
    rules = [{
      protocol = "tcp"; # TCP
      fromPort = 22;
      toPort = 22;
      sourceIp = pkgs.globals.deployerIp + "/32"
    }];
  };
}
