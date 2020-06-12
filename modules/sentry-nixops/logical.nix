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
      config.services.clickhouse-custom.clientPort
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

  snuba = { nodes, config, pkgs, lib, ... }:
  {
    imports = [
      ./snuba.nix
    ];

    services.snuba = {
      enable = true;
      host = "${config.networking.privateIPv4}";
      redisHost = "redis";
      kafkaHost = "kafka";
      clickhouseHost = "clickhouse";
      clickhouseClientPort = nodes.clickhouse.config.services.clickhouse-custom.clientPort;
      clickhouseHttpPort = nodes.clickhouse.config.services.clickhouse-custom.httpPort;
    };

    networking.firewall.allowedTCPPorts = [
      config.services.snuba.port
    ];
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
