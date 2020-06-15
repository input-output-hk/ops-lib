{ config, lib, pkgs, ... }:
let
  cfg = config.services.symbolicator;
in
with lib;
{

  options = {
    services.symbolicator = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      package = mkOption {
        type = types.package;
        default = import ../symbolicator/release.nix { };
        description = ''
          Symbolicator package to use.
        '';
      };

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Host Symbolicator should run on.
        '';
      };
  
      port = mkOption {
        type = types.int;
        default = 3021;
        description = ''
          Port Symbolicator should run on.
        '';
      };
    };
  };

  config =
    let
      symbolicatorCfg = pkgs.writeText "config.yml" ''
        cache_dir: "/tmp/symbolicator"
        bind: "${cfg.host}:${toString cfg.port}"
        logging:
          level: "info"
          format: "auto"
          enable_backtraces: true
        # metrics:
        #   statsd: "127.0.0.1:8125"
        #   prefix: "symbolicator"
      '';
    in mkIf cfg.enable {
      users.users.symbolicator = {
        name = "symbolicator";
        group = "symbolicator";
        description = "Symbolicator user";
      };
  
      users.groups.symbolicator = {};
  
      environment.systemPackages = [
        cfg.package
      ];
  
      services.cron = {
         enable = true;
         systemCronJobs = [
           "55 23 * * *      symbolicator    ${cfg.package}/bin/symbolicator cleanup -c ${symbolicatorCfg}"
         ];
      };
  
      systemd.services.symbolicator = {
        description = "Symbolicator";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
    
        serviceConfig = {
          User = "symbolicator";
          Group = "symbolicator";
          ExecStart = "${cfg.package}/bin/symbolicator run -c ${symbolicatorCfg}";
          Restart="on-failure";
          RestartSec="5s";
        };
      };
    };
}
