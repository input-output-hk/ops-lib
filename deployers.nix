let
  region = "us-east-1";
in {
  defaults = { pkgs, resources, name, ... }: {
    deployment.targetEnv = "ec2";
    deployment.ec2 = {
      accessKeyId = "test";
      inherit region;
      keyPair = resources.ec2KeyPairs.deployers;
      instanceType = "t2.large";
      ebsInitialRootDiskSize = 200;
      elasticIPv4 = resources.elasticIPs."${name}-ip";
    };
    nixpkgs.overlays = [
      (import ./overlays/packages.nix)
    ];
    users.users = {
      root = {
        openssh.authorizedKeys.keys = with pkgs.iohk-ops-lib.ssh-keys; allKeysFrom devOps;
      };
    };
  };
  mainnet-deployer = {};
  staging-deployer = {};
  testnet-deployer = {};
  resources = {
    elasticIPs = let
      ip = {
        accessKeyId = "todo";
        inherit region;
      };
    in {
      mainnet-deployer-ip = ip;
      staging-deployer-ip = ip;
      testnet-deployer-ip = ip;
    };
    ec2KeyPairs.deployers = {
      accessKeyId = "test";
      inherit region;
    };
  };
}
