{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.snuba;
in

{
  imports = [];

  options.services.snuba = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    port = mkOption {
      type = types.int;
      default = 1218;
      description = ''
        Port snuba should run on.
      '';
    };

    package = mkOption {
      type = types.package;
      default = import /home/sam/code/iohk/ops-lib/modules/snuba {};
      example = literalExample "pkgs.snuba";
      description = ''
        The snuba package to use.
      '';
    };

    redisPort = mkOption {
      type = types.int;
      default = config.services.redis.port;
      description = ''
        Port Redis is running on.
      '';
    };

    redisHost = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Host Redis is running on.
      '';
    };

    redisPassword = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Password for the redis database.
        This setting will be ignored if redisPasswordFile is set.
        Using this option will store the password in plain text in the
        world-readable nix store. To avoid this the <literal>redisPasswordFile</literal> can be used.
      '';
    };

    redisPasswordFile = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Password file for the redis database.
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

    kafkaHost = mkOption {
      type = types.str;
      default = config.services.apache-kafka.hostname;
      description = ''
        Host kafka is running on.
      '';
    };

    kafkaPort = mkOption {
      type = types.int;
      default = config.services.apache-kafka.port;
      description = ''
        Port kafka is running on.
      '';
    };

    datadogHost = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Datadog dogstatsd host.
      '';
    };

    datadogPort = mkOption {
      type = types.int;
      default = 8125;
      description = ''
        Datadog dogstatsd port.
      '';
    };

    extraConfig = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Extra snuba configuration.
      '';
    };

  };

  config =
    let
      snubaSettingsPy = pkgs.writeText "settings.py" ''
        import os

        def readPasswordFile(file):
          with open(file, 'r') as fd:
            fd.read()

        LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO")

        TESTING = False
        DEBUG = True

        PORT = ${toString cfg.port} 

        DEFAULT_DATASET_NAME = "events"
        DISABLED_DATASETS = {}
        DATASET_MODE = "local"

        # Clickhouse Options
        # TODO: Warn about using `CLICKHOUSE_SERVER`, users should use the new settings instead.
        [default_clickhouse_host, default_clickhouse_port] = os.environ.get(
            "CLICKHOUSE_SERVER", "${cfg.clickhouseHost}:${toString cfg.clickhouseClientPort}"
        ).split(":", 1)
        CLICKHOUSE_HOST = os.environ.get("CLICKHOUSE_HOST", default_clickhouse_host)
        CLICKHOUSE_PORT = int(os.environ.get("CLICKHOUSE_PORT", default_clickhouse_port))
        CLICKHOUSE_HTTP_PORT = int(os.environ.get("CLICKHOUSE_HTTP_PORT", ${toString cfg.clickhouseHttpPort}))
        CLICKHOUSE_MAX_POOL_SIZE = 25

        # Dogstatsd Options
        DOGSTATSD_HOST = "${cfg.datadogHost}"
        DOGSTATSD_PORT = ${toString cfg.datadogPort}

        # Redis Options
        USE_REDIS_CLUSTER = False
        REDIS_CLUSTER_STARTUP_NODES = None
        REDIS_HOST = "${cfg.redisHost}"
        REDIS_PORT = "${toString cfg.redisPort}"
        REDIS_PASSWORD = ${if cfg.redisPassword != null then "${cfg.redisPassword}" else (if cfg.redisPasswordFile != null then "readPasswordFile(${cfg.redisPasswordFile})" else "None")}
        REDIS_DB = 1

        # Query Recording Options
        RECORD_QUERIES = False
        QUERIES_TOPIC = "snuba-queries"

        # Runtime Config Options
        CONFIG_MEMOIZE_TIMEOUT = 10

        # Sentry Options
        SENTRY_DSN = None

        # Snuba Options

        SNAPSHOT_LOAD_PRODUCT = "snuba"

        SNAPSHOT_CONTROL_TOPIC_INIT_TIMEOUT = 30
        BULK_CLICKHOUSE_BUFFER = 10000

        # Processor/Writer Options
        DEFAULT_BROKERS = ["${cfg.kafkaHost}:${toString cfg.kafkaPort}"]
        DEFAULT_DATASET_BROKERS = {}

        DEFAULT_MAX_BATCH_SIZE = 50000
        DEFAULT_MAX_BATCH_TIME_MS = 2 * 1000
        DEFAULT_QUEUED_MAX_MESSAGE_KBYTES = 10000
        DEFAULT_QUEUED_MIN_MESSAGES = 10000
        DISCARD_OLD_EVENTS = True
        CLICKHOUSE_HTTP_CHUNK_SIZE = 1

        DEFAULT_RETENTION_DAYS = 90
        RETENTION_OVERRIDES = {}

        MAX_PREWHERE_CONDITIONS = 1

        STATS_IN_RESPONSE = False

        PAYLOAD_DATETIME_FORMAT = "%Y-%m-%dT%H:%M:%S.%fZ"

        REPLACER_MAX_BLOCK_SIZE = 512
        REPLACER_MAX_MEMORY_USAGE = 10 * (1024 ** 3)  # 10GB
        # TLL of Redis key that denotes whether a project had replacements
        # run recently. Useful for decidig whether or not to add FINAL clause
        # to queries.
        REPLACER_KEY_TTL = 12 * 60 * 60
        REPLACER_MAX_GROUP_IDS_TO_EXCLUDE = 256

        TURBO_SAMPLE_RATE = 0.1

        PROJECT_STACKTRACE_BLACKLIST = set()

        # Number of queries each subscription consumer can run concurrently.
        SUBSCRIPTIONS_MAX_CONCURRENT_QUERIES = 10
        
        # Extra config
        ${optionalString (cfg.extraConfig != null) cfg.extraConfg}
      '';
    in
    {

    environment.etc = {
      "snuba/settings.py".source = snubaSettingsPy;
    };

    systemd.services.snuba = {
      description = "Snuba API";

      wantedBy = [ "multi-user.target" ];

      after = [ "network.target" "clickhouse.service" "postgresql.service" "apache-kafka.service" "redis.service" ];

      preStart = ''
        set -eu

        ${cfg.package}/bin/snuba bootstrap --force
      '';

      serviceConfig = {
        Environment="SNUBA_SETTINGS=/etc/snuba/settings.py";
        # User = "snuba";
        # Group = "snuba";
        # ConfigurationDirectory = "clickhouse-server";
        # StateDirectory = "clickhouse";
        # LogsDirectory = "clickhouse";
        ExecStart = "${cfg.package}/bin/snuba api";
      };
    };
  };
}
