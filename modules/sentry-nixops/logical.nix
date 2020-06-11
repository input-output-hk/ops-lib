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
    services.memcached.listen = "${nodes.memcached.config.networking.privateIPv4}";

    networking.firewall.allowedTCPPorts = [ config.services.memcached.port ];
  };

  clickhouse = { nodes, config, pkgs, ... }: {
    imports = [
      ./clickhouse-custom.nix
    ];

    services.clickhouse-custom = {
      enable = true;
      listenHost = "${nodes.clickhouse.config.networking.privateIPv4}";
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
      
      DEBUG = env("DEBUG", "0").lower() in ("1", "true")
      
      DEFAULT_BROKERS = "${nodes.kafka.config.networking.privateIPv4}:${toString nodes.kafka.config.services.apache-kafka.port}".split(",")
      
      REDIS_HOST = "${nodes.redis.config.networking.privateIPv4}"
      REDIS_PORT = ${toString nodes.redis.config.services.redis.port}
      REDIS_PASSWORD = ""
      REDIS_DB = int(env("REDIS_DB", 1))
      USE_REDIS_CLUSTER = False
      
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
    };

    users.groups.snuba = {};

    systemd.services.snuba-consumer = {
      description = "Snuba events consumer";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Environment="SNUBA_SETTINGS=${snubaSettingsPy}";
        User = "snuba";
        Group = "snuba";
        ExecStart = "${snuba}/bin/snuba consumer --dataset events --auto-offset-reset=latest --max-batch-time-ms 750";
      };
    };
  };
}
