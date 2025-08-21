{ pkgs, lib, name, config, ... }:
let
  inherit (pkgs.iohk-ops-lib.ssh-keys) allKeysFrom devOps;
  devOpsKeys = allKeysFrom devOps;
in {

  imports = [ ./aws.nix ./monitoring-exporters.nix ./oauth.nix ];
  options = {
    local.commonGivesVim = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "allows making common.nix not install a vim";
    };
  };
  config = {
    networking.hostName = name;

    environment.systemPackages = with pkgs; [
      bat
      git
      graphviz
      htop
      iptables
      jq
      lsof
      mosh
      ncdu
      sysstat
      tcpdump
      tig
      tree
      di
      fd
      file
      ripgrep
    ] ++ (lib.optional config.local.commonGivesVim vim);

    users.mutableUsers = false;
    users.users.root.openssh.authorizedKeys.keys = devOpsKeys;

    services = {
      monitoring-exporters.graylogHost =
        if config.deployment.targetEnv == "ec2"
        then "monitoring-ip:5044"
        else "monitoring:5044";

      openssh = {
        authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
        extraConfig = lib.mkOrder 9999 ''
          Match User root
            AuthorizedKeysFile .ssh/authorized_keys .ssh/authorized_keys2 /etc/ssh/authorized_keys.d/%u
        '';
        settings.PasswordAuthentication = false;
      };

      timesyncd.enable = true;
      cron.enable = true;
    };

    nix = {
      # A recent version of nix daemon is required to be able to migrate to newer nixpkgs, such as 25.05,
      # otherwise an `error: path '/nix/store/...-linux-$VERSION-modules-shrunk/lib` is encountered during build.
      package = (builtins.getFlake "github:nixos/nix/9328af84d33281ef8018251b2a4289e89719c7ae").packages.${pkgs.system}.nix;

      # make sure we have enough build users
      nrBuildUsers = 32;

      # use nix sandboxing for greater determinism
      settings = {
        sandbox = true;

        # use all cores
        cores = 0;

        # use our hydra builds
        substituters = [ "https://cache.nixos.org" "https://cache.iog.io" "https://iohk.cachix.org" ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
          "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
        ];
      };

      # if our hydra is down, don't wait forever
      extraOptions = ''
        connect-timeout = 10
        http2 = true
        show-trace = true
        narinfo-cache-negative-ttl = 0

        # Fetch-closure required by capkgs
        experimental-features = nix-command flakes fetch-closure auto-allocate-uids configurable-impure-env
        allow-import-from-derivation = true

        # To disable warnings on newer nix versions ~ >= 2.19
        auto-allocate-uids = false
        impure-env =
      '';

      # nixpkgs path is created by 'extraSystemBuilderCmds' below:
      nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];
    };

    system.extraSystemBuilderCmds = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';

    # Mosh
    networking.firewall.allowedUDPPortRanges = [{
      from = 60000;
      to = 61000;
    }];

    programs = {
      mosh.enable = true;
      ssh.package = (
        builtins.getFlake "github:nixos/nixpkgs/b9014df496d5b68bf7c0145d0e9b0f529ce4f2a8"
      ).legacyPackages.${pkgs.system}.openssh;
    };
  };
}
