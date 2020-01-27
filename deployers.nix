let
  region = "eu-central-1";
  org = "IOHK";
  accessKeyId = "root-account";
  pkgs = import ./nix {};
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
        securityGroups = with resources; [
          ec2SecurityGroups.allow-ssh
          ec2SecurityGroups.allow-wireguard
        ];
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
      networking.firewall.allowedUDPPorts = [ 17777 ];
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

    deployment.keys."mainnet-deployer.wgprivate" = {
      destDir = "/etc/wireguard";
      keyFile = ./secrets/mainnet-deployer.wgprivate;
    };
    networking.wireguard.interfaces.wg0 = {
      ips = [ "10.90.1.1/32" ];
      listenPort = 17777;
      privateKeyFile = "/etc/wireguard/mainnet-deployer.wgprivate";
      peers = [
        { # mac-mini-1
          publicKey = "nvKCarVUXdO0WtoDsEjTzU+bX0bwWYHJAM2Y3XhO0Ao=";
          allowedIPs = [ "192.168.20.21/32" ];
          persistentKeepalive = 25;
        }
        { # mac-mini-2
          publicKey = "VcOEVp/0EG4luwL2bMmvGvlDNDbCzk7Vkazd3RRl51w=";
          allowedIPs = [ "192.168.20.22/32" ];
          persistentKeepalive = 25;
        }
      ];
    };
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
    ec2SecurityGroups = let
      fn = x: __head (__attrValues x);
    in with (import ./physical/aws/security-groups); {
      allow-ssh = fn (allow-ssh { inherit pkgs region org accessKeyId; });
      allow-wireguard = fn (allow-wireguard { inherit pkgs region org accessKeyId; });
    };
  };
}
