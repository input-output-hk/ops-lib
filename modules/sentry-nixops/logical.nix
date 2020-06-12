let
  snuba = import ../snuba {};
  sentry = import ../sentry {};
in
{
  network = {
    description = "Sentry monitoring and error tracking framework.";
  };

  redis = { config, pkgs, ... }: {
    services.redis.enable = true;

    networking.firewall.allowedTCPPorts = [ config.services.redis.port ];
  };

  memcached = { nodes, config, pkgs, ... }: {
    services.memcached.enable = true;
    services.memcached.listen = "${config.networking.privateIPv4}";

    networking.firewall.allowedTCPPorts = [ config.services.memcached.port ];
  };

  clickhouse = { nodes, config, pkgs, ... }: {
    imports = [
      ./clickhouse-custom.nix
    ];

    services.clickhouse-custom = {
      enable = true;
      listenHost = "${config.networking.privateIPv4}";
    };

    networking.firewall.allowedTCPPorts = [
      config.services.clickhouse-custom.httpPort
      config.services.clickhouse-custom.tcpPort
    ];
  };

  postgres = { nodes, config, pkgs, ... }: {
    services.postgresql.enable = true;
    services.postgresql.enableTCPIP = true;

    networking.firewall.allowedTCPPorts = [
      config.services.postgresql.port
    ];
  };

  zookeeper = { nodes, config, pkgs, ... }: {
    services.zookeeper.enable = true;
    # services.zookeeper.servers = ''
    #     server.${config.services.zookeeper.id}=${nodes.zookeeper.config.networking.privateIPv4}:2888:3888
    # '';

    networking.firewall.allowedTCPPorts = [
      config.services.zookeeper.port
    ];
  };

  kafka = { nodes, config, pkgs, ... }: {
    services.apache-kafka.enable = true;
    services.apache-kafka.zookeeper = "zookeeper:${toString nodes.zookeeper.config.services.zookeeper.port}";
    services.apache-kafka.hostname = "${config.networking.privateIPv4}";
    services.apache-kafka.extraProperties = ''
      advertised.listeners: PLAINTEXT://${config.networking.privateIPv4}:${toString config.services.apache-kafka.port}
      offsets.topic.replication.factor: 1
    '';

    networking.firewall.allowedTCPPorts = [
      config.services.apache-kafka.port
    ];
  };

  snuba = { nodes, config, pkgs, ... }:
  let
    snubaSettingsPy = pkgs.writeText "settings.py" ''
      import os
      from snuba.settings_base import *  # NOQA
    
      env = os.environ.get

      def readPasswordFile(file):
        with open(file, 'r') as fd:
          fd.read()

      PORT = 1219
      
      DEBUG = env("DEBUG", "0").lower() in ("1", "true")
      
      DEFAULT_BROKERS = "kafka:${toString nodes.kafka.config.services.apache-kafka.port}".split(",")
      
      REDIS_HOST = "redis"
      REDIS_PORT = ${toString nodes.redis.config.services.redis.port}
      REDIS_PASSWORD = ""
      REDIS_DB = int(env("REDIS_DB", 1))
      USE_REDIS_CLUSTER = False

      # Clickhouse Options
      CLICKHOUSE_HOST = "clickhouse"
      CLICKHOUSE_PORT = ${toString nodes.clickhouse.config.services.clickhouse-custom.tcpPort}
      CLICKHOUSE_HTTP_PORT = ${toString nodes.clickhouse.config.services.clickhouse-custom.httpPort}
      CLICKHOUSE_MAX_POOL_SIZE = 25
      
      # Dogstatsd Options
      DOGSTATSD_HOST = None
      DOGSTATSD_PORT = None
    '';
  in
  {
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
      snuba
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
      snuba-api = common // {
        description = "Snuba API";
        serviceConfig.ExecStart = "${snuba}/bin/snuba api";
      };

      snuba-consumer = common // {
        description = "Snuba events consumer";
        serviceConfig.ExecStart = "${snuba}/bin/snuba consumer --dataset events --auto-offset-reset=latest --max-batch-time-ms 750";
      };

      snuba-outcomes-consumer = common // {
        description = "Snuba outcomes consumer";
        serviceConfig.ExecStart = "${snuba}/bin/snuba consumer --storage outcomes_raw --auto-offset-reset=earliest --max-batch-time-ms 750";
      };

      # Seems to be no sessions dataset in this version of snuba
      # snuba-sessions-consumer = common // {
      #   description = "Snuba sessions consumer";
      #   serviceConfig.ExecStart = "${snuba}/bin/snuba consumer --dataset sessions_raw --auto-offset-reset=latest --max-batch-time-ms 750";
      # };

      snuba-replacer = common // {
        description = "Snuba replacer";
        serviceConfig.ExecStart = "${snuba}/bin/snuba replacer --dataset events --auto-offset-reset=latest --max-batch-size 3";
      };

      snuba-init = {
        description = "Create Kafka topics and Clickhouse tables for Snuba";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        script = ''
          wait_for_open_port() {
            local hostname="$1"
            local port="$2"
            local num_tried=0
            local status=1
            
            while [ $status -ne 0 -a $num_tried -lt 900 ];
            do
              ${pkgs.netcat}/bin/nc -z $hostname $port
              status=$?
              num_tried=$(($num_tried + 1))
              sleep 1
            done
          
            return $status
          }
          
          wait_for_open_port kafka 9092
          kafka=$?
          wait_for_open_port clickhouse 8123
          clickhouse=$?
          
          if [ $kafka -eq 0 -a $clickhouse -eq 0 ]
          then
            SNUBA_SETTINGS=${snubaSettingsPy} ${snuba}/bin/snuba bootstrap --force
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

  # sentry = { nodes, config, pkgs, ... }: {
      # $dcr web upgrade --noinput
      # echo ""
      # echo "Did not prompt for user creation due to non-interactive shell."
      # echo "Run the following command to create one yourself (recommended):"
      # echo ""
      # echo "  docker-compose run --rm web createuser"
      # echo ""
  # };
}
