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
    services.redis.bind = "0.0.0.0";

    networking.firewall.allowedTCPPorts = [ config.services.redis.port ];
  };

  memcached = { nodes, config, pkgs, ... }: {
    services.memcached.enable = true;
    services.memcached.listen = "${config.networking.privateIPv4}";
    # The memcached service fails to bind to an address sometimes
    systemd.services.memcached.serviceConfig.Restart="on-failure";
    systemd.services.memcached.serviceConfig.RestartSec="5s";

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

  postgres = { nodes, config, pkgs, ... }:
    let
      sentryDb = nodes.sentry.config.services.sentry.dbName;
      sentryDbUser = nodes.sentry.config.services.sentry.dbUser;
      initialScript = pkgs.writeText "initialScript.psql" ''
        CREATE DATABASE ${sentryDb};
        CREATE USER ${sentryDbUser};
        GRANT ALL PRIVILEGES ON DATABASE ${sentryDb} to ${sentryDbUser};
        ALTER USER ${sentryDbUser} WITH SUPERUSER;
      '';
    in {
      services.postgresql.enable = true;
      services.postgresql.enableTCPIP = true;
      services.postgresql.initialScript = initialScript;
      services.postgresql.authentication = ''
        # TYPE  DATABASE    USER              CIDR-ADDRESS                                           METHOD
        host    ${sentryDb} ${sentryDbUser}   ${nodes.sentry.config.networking.privateIPv4}/32       trust 
      '';
  
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
      redisPort = nodes.redis.config.services.redis.port;
      kafkaHost = "kafka";
      kafkaPort = nodes.kafka.config.services.apache-kafka.port;
      clickhouseHost = "clickhouse";
      clickhouseClientPort = nodes.clickhouse.config.services.clickhouse-custom.clientPort;
      clickhouseHttpPort = nodes.clickhouse.config.services.clickhouse-custom.httpPort;
    };

    networking.firewall.allowedTCPPorts = [
      config.services.snuba.port
    ];
  };

  sentry = { nodes, config, pkgs, ... }: {
    imports = [
      ./sentry.nix
    ];

    services.sentry = {
      enable = true;
      hostname = "${config.networking.privateIPv4}";
      secretKey = "^a^r_qh++*d9bioobt==r0ukdw!2ipb-#os-uxn!_w3bh0)!k8";

      redisHost = "redis";
      redisPort = nodes.redis.config.services.redis.port;

      postgresqlHost = "postgres";
      postgresqlPort = nodes.postgres.config.services.postgresql.port;

      kafkaHost = "kafka";
      kafkaPort = nodes.kafka.config.services.apache-kafka.port;

      snubaHost = "snuba";
      snubaPort = nodes.snuba.config.services.snuba.port;

      memcachedHost = "memcached";
      memcachedPort = nodes.memcached.config.services.memcached.port;

      symbolicatorHost = "symbolicator";
      symbolicatorPort = nodes.symbolicator.config.services.symbolicator.port;
    };

    networking.firewall.allowedTCPPorts = [
      config.services.sentry.port
    ];
  };

  symbolicator = { nodes, config, pkgs, ... }: {
    imports = [
      ./symbolicator.nix
    ];

    services.symbolicator = {
      enable = true;
      host = "${config.networking.privateIPv4}";
    };

    networking.firewall.allowedTCPPorts = [
      config.services.symbolicator.port
    ];
  };
}
