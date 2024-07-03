let
  region = "eu-central-1";
  org = "IOHK";
  accessKeyId = "root-account";
  pkgs = import ../nix { config.allowUnfree = true; };
in {
  defaults = { resources, name, config, lib, nodes, ... }: {
    options = {
      local.username = lib.mkOption {
        type = lib.types.str;
      };
    };
    imports = [
      ../modules/deployer.nix
      ../modules/vims.nix
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
      boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
      programs = {
        bash.interactiveShellInit = ''
          eval "$(direnv hook bash)"
        '';
        fzf = {
          fuzzyCompletion = true;
          keybindings = true;
        };
        starship = {
          enable = true;
          settings = {
            git_commit = {
              tag_disabled = false;
              only_detached = false;
            };
            git_metrics = {
              disabled = false;
            };
            memory_usage = {
              disabled = false;
              format = "via $symbol[\${ram_pct}]($style) ";
              threshold = -1;
            };
            shlvl = {
              disabled = false;
              symbol = "↕";
              threshold = -1;
            };
            status = {
              disabled = false;
              map_symbol = true;
              pipestatus = true;
            };
            time = {
              disabled = false;
              format = "[\\[ $time \\]]($style) ";
            };
          };
        };
      };
      # Used by starship for fonts
      fonts.packages = with pkgs; [
        (nerdfonts.override {fonts = ["FiraCode"];})
      ];
      environment = {
        systemPackages = with pkgs; [
          direnv
        ];
        variables.DEPLOYER_IP = toString config.networking.publicIPv4;
      };
      nixpkgs = { inherit pkgs; };
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
    users.users.exchanges = {
      openssh.authorizedKeys.keys = with pkgs.iohk-ops-lib.ssh-keys; allKeysFrom devOps;
      isNormalUser = true;
    };
    nix.trustedUsers = [ "root" "ci" ];
    environment.etc."client_ssh_sample".text = lib.concatStringsSep "\n" (map
      (name: ''
        Host ${name}
          User ${nodes.${name}.config.local.username}
          HostName ${toString nodes.${name}.config.networking.publicIPv4}
      '') [ "mainnet-deployer" "staging-deployer" "testnet-deployer" "dev-deployer" ]);

    deployment.keys."mainnet-deployer.wgprivate" = {
      destDir = "/etc/wireguard";
      keyFile = ../secrets/mainnet-deployer.wgprivate;
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
    services.tarsnap = {
      enable = true;
      keyfile = "/run/keys/tarsnap";
      archives = { inherit (import ../secrets/tarsnap-archives.nix) mainnet-deployer; };
    };
    deployment.keys.tarsnap = {
      destDir = "/run/keys";
      keyFile = ../secrets/tarsnap-mainnet-deployer-readwrite.secret;
    };
  };

  staging-deployer = {
    local.username = "staging";
    services.tarsnap = {
      enable = true;
      keyfile = "/run/keys/tarsnap";
      archives = { inherit (import ../secrets/tarsnap-archives.nix) staging-deployer; };
    };
    deployment.keys.tarsnap = {
      destDir = "/run/keys";
      keyFile = ../secrets/tarsnap-staging-deployer-readwrite.secret;
    };
  };

  testnet-deployer = {
    local.username = "testnet";
    deployment.ec2.instanceType = "r5a.xlarge";
    services.tarsnap = {
      enable = true;
      keyfile = "/run/keys/tarsnap";
      archives = { inherit (import ../secrets/tarsnap-archives.nix) testnet-deployer; };
    };
    deployment.keys.tarsnap = {
      destDir = "/run/keys";
      keyFile = ../secrets/tarsnap-testnet-deployer-readwrite.secret;
    };
  };

  dev-deployer = { pkgs, ... }: {
    local.username = "dev";
    users.users.dev = {
      openssh.authorizedKeys.keys = with pkgs.iohk-ops-lib.ssh-keys; (allKeysFrom csl-developers ++ allKeysFrom plutus-developers);
    };
    services.tarsnap = {
      enable = true;
      keyfile = "/run/keys/tarsnap";
      archives = { inherit (import ../secrets/tarsnap-archives.nix) dev-deployer; };
    };
    deployment.keys.tarsnap = {
      destDir = "/run/keys";
      keyFile = ../secrets/tarsnap-dev-deployer-readwrite.secret;
    };
  };

  bench-deployer = { pkgs, ... }: {
    local.username = "dev";
    fileSystems."/home" =
      { device = "/dev/disk/by-label/home";
        fsType = "ext4";
      };
    deployment.ec2.instanceType = "c5.9xlarge";
    deployment.ec2.ebsInitialRootDiskSize = pkgs.lib.mkForce 2000;
    users.users.dev = {
      openssh.authorizedKeys.keys = with pkgs.iohk-ops-lib.ssh-keys; allKeysFrom csl-developers;
    };
    nix.nrBuildUsers = pkgs.lib.mkForce 36;
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
      bench-deployer-ip = ip;
    };
    ec2KeyPairs.deployers = {
      inherit region accessKeyId;
    };
    ec2SecurityGroups = let
      fn = x: builtins.head (builtins.attrValues x);
    in with (import ../physical/aws/security-groups); {
      allow-ssh = fn (allow-ssh { inherit pkgs region org accessKeyId; });
      allow-wireguard = fn (allow-wireguard { inherit pkgs region org accessKeyId; });
    };
  };
}
