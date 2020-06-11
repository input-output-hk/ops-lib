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
}
