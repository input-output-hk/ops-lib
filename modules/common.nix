{ pkgs, lib, name, config, ... }:
let
  inherit (pkgs.iohk-ops-lib.ssh-keys) allKeysFrom devOps;
  devOpsKeys = allKeysFrom devOps;
in {

  imports = [ ./aws.nix ./monitoring-exporters.nix ];
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
      (ruby.withPackages (ps: with ps; [ sequel pry sqlite3 nokogiri ]))
      bat
      di
      fd
      file
      git
      graphviz
      htop
      iptables
      jq
      lsof
      mosh
      ncdu
      ripgrep
      screen
      sqlite-interactive
      sysstat
      tcpdump
      tig
      tmux
      tree
    ] ++ (lib.optional config.local.commonGivesVim vim);

    environment.variables.TERM = "xterm-256color";

    users.mutableUsers = false;
    users.users.root.openssh.authorizedKeys.keys = devOpsKeys;

    services = {
      monitoring-exporters.graylogHost =
        if config.deployment.targetEnv == "ec2"
        then "monitoring-ip:5044"
        else "monitoring:5044";

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
        narinfo-cache-negative-ttl = 0
      '';

      # use all cores
      buildCores = 0;

      #nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];

      # use our hydra builds
      binaryCaches = [ "https://cache.nixos.org" "https://hydra.iohk.io" "https://iohk.cachix.org" ];
      binaryCachePublicKeys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      ];
    };

    # Mosh
    networking.firewall.allowedUDPPortRanges = [{
      from = 60000;
      to = 61000;
    }];
    programs = {
      mosh.enable = true;
      screen.screenrc = ''
        defscrollback 10000
        #caption always
        maptimeout 5
        escape ^aa  # default
        autodetach            on              # default: on
        crlf                  off             # default: off
        hardcopy_append       on              # default: off
        startup_message       off             # default: on
        vbell                 off             # default: ???
        defmonitor            on
        defscrollback         1000            # default: 100
        silencewait           15              # default: 30
        shelltitle "Shell"
        hardstatus alwayslastline "%{b}[ %{B}%H %{b}][ %{w}%?%-Lw%?%{b}(%{W}%n*%f %t%?(%u)%?%{b})%{w}%?%+Lw%?%?%= %{b}][%{B} %Y-%m-%d %{W}%c %{b}]"
        sorendition   gk  #red    on white
        bell                  "%C -> %n%f %t Bell!~"
        pow_detach_msg        "BYE"
        vbell_msg             " *beep* "
        bind .
        bind ^\
        bind \\
        bind e mapdefault
        msgwait 2
      '';
    };
  };
}
