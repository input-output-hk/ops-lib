let
  region = "eu-central-1";
  accessKeyId = "root-account";
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
        inherit region accessKeyId;
        keyPair = resources.ec2KeyPairs.deployers;
        instanceType = lib.mkDefault "r5a.xlarge";
        ebsInitialRootDiskSize = 200;
        elasticIPv4 = resources.elasticIPs."${name}-ip";
      };
      services.lorri.enable = true;
      programs.bash.interactiveShellInit = ''
        eval "$(direnv hook bash)"
      '';
      environment = {
        systemPackages = with pkgs; [
          direnv
        ];
        variables.DEPLOYER_IP = toString config.networking.publicIPv4;
      };
      nixpkgs.overlays = [
        (import ./overlays/packages.nix)
      ];
      users.users = {
        ${config.local.username} = {
          isNormalUser = true;
          openssh.authorizedKeys.keys = with pkgs.iohk-ops-lib.ssh-keys; allKeysFrom devOps;
        };
      };
    };
  };
  mainnet-deployer = { pkgs, lib, nodes, ... }: {
    local.username = "mainnet";
    users.users.ci = {
      openssh.authorizedKeys.keys = with pkgs.iohk-ops-lib.ssh-keys; allKeysFrom devOps;
      isNormalUser = true;
    };
    environment.etc."client_ssh_sample".text = lib.concatStringsSep "\n" (map
      (name: ''
        Host ${name}
          User ${nodes.${name}.config.local.username}
          HostName ${toString nodes.${name}.config.networking.publicIPv4}
      '') [ "mainnet-deployer" "staging-deployer" "testnet-deployer" "dev-deployer" ]);
  };
  staging-deployer = {
    local.username = "staging";
  };
  testnet-deployer = {
    local.username = "testnet";
    deployment.ec2.instanceType = "r5a.xlarge";
  };
  dev-deployer = { pkgs, ... }: {
    local.username = "dev";
    users.users.dev = {
      openssh.authorizedKeys.keys = with pkgs.iohk-ops-lib.ssh-keys; allKeysFrom csl-developers;
    };
  };
  resources = {
    elasticIPs = let
      ip = {
        inherit region accessKeyId;
      };
    in {
      mainnet-deployer-ip = ip;
      staging-deployer-ip = ip;
      testnet-deployer-ip = ip;
      dev-deployer-ip = ip;
    };
    ec2KeyPairs.deployers = {
      inherit region accessKeyId;
    };
  };
}
