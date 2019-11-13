{ region, org, pkgs, lib, ... }: {
  "allow-deployer-ssh-${region}-${org}" = {
    inherit region;
    accessKeyId = pkgs.globals.ec2.credentials.accessKeyIds.${org};
    _file = ./allow-deployer-ssh.nix;
    description = "SSH";
    rules = [{
      protocol = "tcp"; # TCP
      fromPort = 22;
      toPort = 22;
      sourceIp = pkgs.globals.deployerIp + "/32";
    }];
  };
}
