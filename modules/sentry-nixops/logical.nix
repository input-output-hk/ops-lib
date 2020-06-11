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

  # snuba = { nodes, config, pkgs, ... }:
  # let
  #   snubaSettingsPy = pkgs.writeText "settings.py" ''
  #     import os
    
  #     def readPasswordFile(file):
  #       with open(file, 'r') as fd:
  #         fd.read()
    
  #     LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO")
    
  #     TESTING = False
  #     DEBUG = True
    
  #     PORT = ${toString cfg.port} 
    
  #     DEFAULT_DATASET_NAME = "events"
  #     DISABLED_DATASETS = {}
  #     DATASET_MODE = "local"
    
  #     # Clickhouse Options
  #     # TODO: Warn about using `CLICKHOUSE_SERVER`, users should use the new settings instead.
  #     [default_clickhouse_host, default_clickhouse_port] = os.environ.get(
  #         "CLICKHOUSE_SERVER", "${cfg.clickhouseHost}:${toString cfg.clickhouseClientPort}"
  #     ).split(":", 1)
  #     CLICKHOUSE_HOST = os.environ.get("CLICKHOUSE_HOST", default_clickhouse_host)
  #     CLICKHOUSE_PORT = int(os.environ.get("CLICKHOUSE_PORT", default_clickhouse_port))
  #     CLICKHOUSE_HTTP_PORT = int(os.environ.get("CLICKHOUSE_HTTP_PORT", ${toString cfg.clickhouseHttpPort}))
  #     CLICKHOUSE_MAX_POOL_SIZE = 25
    
  #     # Dogstatsd Options
  #     DOGSTATSD_HOST = "${cfg.datadogHost}"
  #     DOGSTATSD_PORT = ${toString cfg.datadogPort}
    
  #     # Redis Options
  #     USE_REDIS_CLUSTER = False
  #     REDIS_CLUSTER_STARTUP_NODES = None
  #     REDIS_HOST = "${cfg.redisHost}"
  #     REDIS_PORT = "${toString cfg.redisPort}"
  #     REDIS_PASSWORD = ${if cfg.redisPasswordFile != null then "readPasswordFile(${cfg.redisPasswordFile})" else (if cfg.redisPassword != null then "${cfg.redisPassword}" else "None")}
  #     REDIS_DB = 1
    
  #     # Query Recording Options
  #     RECORD_QUERIES = False
  #     QUERIES_TOPIC = "snuba-queries"
    
  #     # Runtime Config Options
  #     CONFIG_MEMOIZE_TIMEOUT = 10
    
  #     # Sentry Options
  #     SENTRY_DSN = None
    
  #     # Snuba Options
    
  #     SNAPSHOT_LOAD_PRODUCT = "snuba"
    
  #     SNAPSHOT_CONTROL_TOPIC_INIT_TIMEOUT = 30
  #     BULK_CLICKHOUSE_BUFFER = 10000
    
  #     # Processor/Writer Options
  #     DEFAULT_BROKERS = ["${cfg.kafkaHost}:${toString cfg.kafkaPort}"]
  #     DEFAULT_DATASET_BROKERS = {}
    
  #     DEFAULT_MAX_BATCH_SIZE = 50000
  #     DEFAULT_MAX_BATCH_TIME_MS = 2 * 1000
  #     DEFAULT_QUEUED_MAX_MESSAGE_KBYTES = 10000
  #     DEFAULT_QUEUED_MIN_MESSAGES = 10000
  #     DISCARD_OLD_EVENTS = True
  #     CLICKHOUSE_HTTP_CHUNK_SIZE = 1
    
  #     DEFAULT_RETENTION_DAYS = 90
  #     RETENTION_OVERRIDES = {}
    
  #     MAX_PREWHERE_CONDITIONS = 1
    
  #     STATS_IN_RESPONSE = False
    
  #     PAYLOAD_DATETIME_FORMAT = "%Y-%m-%dT%H:%M:%S.%fZ"
    
  #     REPLACER_MAX_BLOCK_SIZE = 512
  #     REPLACER_MAX_MEMORY_USAGE = 10 * (1024 ** 3)  # 10GB
  #     # TLL of Redis key that denotes whether a project had replacements
  #     # run recently. Useful for decidig whether or not to add FINAL clause
  #     # to queries.
  #     REPLACER_KEY_TTL = 12 * 60 * 60
  #     REPLACER_MAX_GROUP_IDS_TO_EXCLUDE = 256
    
  #     TURBO_SAMPLE_RATE = 0.1
    
  #     PROJECT_STACKTRACE_BLACKLIST = set()
    
  #     # Number of queries each subscription consumer can run concurrently.
  #     SUBSCRIPTIONS_MAX_CONCURRENT_QUERIES = 10
      
  #     # Extra config
  #     ${optionalString (cfg.extraConfig != null) cfg.extraConfg}
  #   '';
  
  # in
  # {
  #   # consumer --storage events --auto-offset-reset=latest --max-batch-time-ms 750
  # };
}
