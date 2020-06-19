{ config, lib, pkgs, ... }:
let
  cfg = config.services.snuba;
in
with lib;
{

  options = {
    services.snuba = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run the snuba suite of services.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.snuba;
        example = literalExample "pkgs.snuba";
        description = ''
          Snuba package to use.
        '';
      };
  
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Host Snuba should run on.
        '';
      };
  
      port = mkOption {
        type = types.int;
        default = 1218;
        description = ''
          Port snuba should run on.
        '';
      };
  
      redisHost = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Host Redis is running on.
        '';
      };
  
      redisPort = mkOption {
        type = types.int;
        default = config.services.redis.port;
        description = ''
          Port Redis is running on.
        '';
      };
  
      redisDb = mkOption {
        type = types.int;
        default = 1;
        description = ''
          Redis database to use.
        '';
      };
  
      kafkaHost = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Host Kafka is running on.
        '';
      };
  
      kafkaPort = mkOption {
        type = types.int;
        default = config.services.apache-kafka.port;
        description = ''
          Port Kafka is running on.
        '';
      };
  
      clickhouseHost = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Host clickhouse is running on.
        '';
      };
  
      clickhouseClientPort = mkOption {
        type = types.int;
        default = 9000;
        description = ''
          Port clickhouse server is running on. Note that clickhouse
          server listens on multiple ports, this port is the port
          clickhouse client should use.
        '';
      };
  
      clickhouseHttpPort = mkOption {
        type = types.int;
        default = 8123;
        description = ''
          Port clickhouse HTTP server is running on. Note that
          clickhouse server listens on multiple ports, this port is the
          port for the HTTP server.
        '';
      };
    };
  };

  config =
    let
      snubaSettingsPy = pkgs.writeText "settings.py" ''
        import os
        from snuba.settings_base import *  # NOQA
      
        env = os.environ.get
  
        def readPasswordFile(file):
          with open(file, 'r') as fd:
            fd.read()
  
        HOST = "${cfg.host}"
        PORT = ${toString cfg.port}
        
        DEBUG = env("DEBUG", "0").lower() in ("1", "true")
        
        DEFAULT_BROKERS = "${cfg.kafkaHost}:${toString cfg.kafkaPort}".split(",")
        
        REDIS_HOST = "${cfg.redisHost}"
        REDIS_PORT = ${toString cfg.redisPort}
        REDIS_PASSWORD = ""
        REDIS_DB = ${toString cfg.redisDb}
        USE_REDIS_CLUSTER = False
  
        # Clickhouse Options
        CLICKHOUSE_HOST = "${cfg.clickhouseHost}"
        CLICKHOUSE_PORT = ${toString cfg.clickhouseClientPort}
        CLICKHOUSE_HTTP_PORT = ${toString cfg.clickhouseHttpPort}
        CLICKHOUSE_MAX_POOL_SIZE = 25
        
        # Dogstatsd Options
        DOGSTATSD_HOST = None
        DOGSTATSD_PORT = None
      '';
    in mkIf cfg.enable {
      users.users.snuba = {
        name = "snuba";
        group = "snuba";
        description = "Snuba user";
        createHome = true;
        uid = 103;
        home = "/home/snuba";
      };
  
      users.groups.snuba.gid = 103;
  
      environment.systemPackages = [
        cfg.package
      ];
  
      services.cron = {
         enable = true;
         systemCronJobs = [
           "*/5 * * * *      snuba    SNUBA_SETTINGS=${snubaSettingsPy} snuba cleanup --dry-run False"
         ];
      };
  
      systemd.services =
      let
        common = {
          wantedBy = [ "multi-user.target" ];
          requires = [ "snuba-init.service" ];
          after = [ "network.target" "snuba-init.service" ];
    
          serviceConfig = {
            Environment="SNUBA_SETTINGS=${snubaSettingsPy}";
            User = "snuba";
            Group = "snuba";
            Restart="on-failure";
            RestartSec="5s";
          };
        };
      in {
        snuba-api = lib.recursiveUpdate common {
          description = "Snuba API";
          serviceConfig.ExecStart = "${cfg.package}/bin/snuba api";
        };
  
        snuba-consumer = lib.recursiveUpdate common {
          description = "Snuba events consumer";
          serviceConfig.ExecStart = "${cfg.package}/bin/snuba consumer --dataset events --auto-offset-reset=latest --max-batch-time-ms 750";
        };

  
        snuba-outcomes-consumer = lib.recursiveUpdate common {
          description = "Snuba outcomes consumer";
          serviceConfig.ExecStart = "${cfg.package}/bin/snuba consumer --dataset outcomes --auto-offset-reset=earliest --max-batch-time-ms 750";
        };
  
        snuba-replacer = lib.recursiveUpdate common {
          description = "Snuba replacer";
          serviceConfig.ExecStart = "${cfg.package}/bin/snuba replacer --auto-offset-reset=latest --max-batch-size 3";
        };
  
        snuba-init = {
          description = "Create Kafka topics and Clickhouse tables for Snuba";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
  
          script = ''
            wait_for_open_port() {
              local hostname="$1"
              local port="$2"
  
              ${pkgs.coreutils}/bin/timeout 5m ${pkgs.bash}/bin/bash -c "until ${pkgs.netcat}/bin/nc -z $hostname $port -w 1; do echo \"polling $hostname:$port...\"; done"
            }
            
            wait_for_open_port ${cfg.kafkaHost} ${toString cfg.kafkaPort}
            kafka=$?
            wait_for_open_port ${cfg.clickhouseHost} ${toString cfg.clickhouseHttpPort}
            clickhouse=$?
            
            if [ $kafka -eq 0 -a $clickhouse -eq 0 ]
            then
              SNUBA_SETTINGS=${snubaSettingsPy} ${cfg.package}/bin/snuba bootstrap --force
            else
              exit 1
            fi
          '';
  
          serviceConfig = {
            Type="oneshot";
            RemainAfterExit = true;
            User = "snuba";
            Group = "snuba";
          };
        };
      };
    };
}
