let
  region = "us-east-1";
in {
  defaults = { pkgs, resources, name, config, lib, nodes, ... }: {
    options = {
      local.username = lib.mkOption {
        type = lib.types.str;
      };
    };
    imports = [
      ./modules/common.nix
      ./modules/vims.nix
    ];
    config = {
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
        ${config.local.username} = {
          openssh.authorizedKeys.keys = with pkgs.iohk-ops-lib.ssh-keys; allKeysFrom devOps;
        };
      };
      # temporary idea
      environment.etc."client_ssh_sample".text = lib.concatStringsSep "\n" (map
        (name: ''
          Host ${name}
            User ${nodes.${name}.config.local.username}
            HostName ${toString nodes.${name}.config.networking.publicIPv4}
        '') [ "mainnet-deployer" "staging-deployer" "testnet-deployer" ]);
    };
  };
  mainnet-deployer = {
    local.username = "live-production";
  };
  staging-deployer = {
    local.username = "staging";
  };
  testnet-deployer = {
    local.username = "testnet";
  };
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
