{ pkgs, lib, name, config, ... }:
let
  inherit (pkgs.iohk-ops-lib.ssh-keys) allKeysFrom devOps;
  devOpsKeys = allKeysFrom devOps;
in {

  imports = [ ./aws.nix ./monitoring-exporters.nix ];

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
    vim
  ];

  environment.variables.TERM = "xterm-256color";

  users.mutableUsers = false;
  users.users.root.openssh.authorizedKeys.keys = devOpsKeys;

  services = {
    monitoring-exporters.graylogHost =
      if config.deployment.targetEnv == "ec2"
      then "monitoring-ip:5044"
      else "monitoring:5044";

    nginx.mapHashBucketSize =
      if config.deployment.targetEnv == "libvirtd" then 128 else null;

    openssh = {
      passwordAuthentication = false;
      authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
      extraConfig = lib.mkOrder 9999 ''
        Match User root
          AuthorizedKeysFile .ssh/authorized_keys .ssh/authorized_keys2 /etc/ssh/authorized_keys.d/%u
      '';
    };

    ntp.enable = true;
    cron.enable = true;
  };

  nix = rec {
    # use nix sandboxing for greater determinism
    useSandbox = true;

    # make sure we have enough build users
    nrBuildUsers = 32;

    # if our hydra is down, don't wait forever
    extraOptions = ''
      connect-timeout = 10
      http2 = true
      show-trace = true
    '';

    # use all cores
    buildCores = 0;

    nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];

    # use our hydra builds
    trustedBinaryCaches = [ "https://cache.nixos.org" "https://hydra.iohk.io" ];
    binaryCaches = trustedBinaryCaches;
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  };

  system.extraSystemBuilderCmds = ''
    ln -sv ${pkgs.path} $out/nixpkgs
  '';

  # Mosh
  networking.firewall.allowedUDPPortRanges = [{
    from = 60000;
    to = 61000;
  }];
}
