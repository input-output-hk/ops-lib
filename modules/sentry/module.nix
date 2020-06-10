{ config, pkgs, lib, ... }: 

with lib;

let
  cfg = config.services.sentry;

  uwsgiWithPython = (pkgs.uwsgi.override { plugins = [ "python2" ]; }).overrideAttrs(oldDrv: {
    buildInputs = oldDrv.buildInputs ++ [
      pkgs.makeWrapper
    ];

    installPhase = oldDrv.installPhase + ''
      runHook postInstall
    '';

    postInstall = (oldDrv.postInstall or "") + ''
      mv $out/bin/uwsgi $out/bin/uwsgi-wrapped
      makeWrapper "$out/bin/uwsgi-wrapped" "$out/bin/uwsgi" \
        --add-flags "--plugin $out/lib/uwsgi/python2_plugin.so"
    '';
  });

  passwordFileOrPasswordOr = other: passwordFile: password:
    if passwordFile != null
    then "readPasswordFile(${passwordFile})"
    else (if password != null
          then "${password}"
          else other
         )
      
in

{
  imports = [];

  options.services.sentry = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    secretKey = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Secret key for sentry.
        Generate one with "sentry config generate-secret-key".
        This setting will be ignored if secretKeyFile is set.
        Using this option will store the password in plain text in the
        world-readable nix store. To avoid this the <literal>secretKeyFile</literal> can be used.
      '';
    };

    secretKeyFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        Path to file containing the secret key Sentry should use.
        Generate one with "sentry config generate-secret-key".
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

    postgresqlHost = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Host Postgresql is running on.
      '';
    };

    postgresqlPort = mkOption {
      type = types.int;
      default = config.services.postgresql.port;
      description = ''
        Port Postgresql is running on.
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

    snubaPort = mkOption {
      type = types.int;
      default = config.services.snuba.port;
      description = ''
        Port Snuba is running on.
      '';
    };
  };

  config =
    let
      sentryConfigYml = pkgs.writeText "config.yml" ''
      mail.backend: 'dummy';

      redis.clusters:
        default:
          hosts:
            0:
              host: ${cfg.redisHost}
              port: ${toString cfg.redisPort}
      filestore.backend: 'filesystem'
      filestore.options:
        location: '/tmp/sentry-files'
      '';

      sentryConfPy = pkgs.writeText "sentry.conf.py" ''
      # This file is just Python, with a touch of Django which means
      # you can inherit and tweak settings to your hearts content.
      from sentry.conf.server import *
      
      import os.path
      import os
      
      def readPasswordFile(file):
        with open(file, 'r') as fd:
          fd.read()
      
      CONF_ROOT = os.path.dirname(__file__)
      
      DATABASES = {
          'default': {
              'ENGINE': 'sentry.db.postgres',
              'NAME': '${cfg.sentrydbName}',
              'USER': '${cfg.sentrydbUser}',
              'PASSWORD': '${(passwordFileOrPasswordOr "") cfg.postgresqlPasswordFile cfg.postgresqlPassword}',
              'HOST': '${cfg.postgresqlHost}',
              'PORT': '${toString cfg.postgresqlPort}',
              'AUTOCOMMIT': True,
              'ATOMIC_REQUESTS': False,
          }
      }
      
      # You should not change this setting after your database has been created
      # unless you have altered all schemas first
      SENTRY_USE_BIG_INTS = True
      
      # If you're expecting any kind of real traffic on Sentry, we highly recommend
      # configuring the CACHES and Redis settings
      
      ###########
      # General #
      ###########
      
      # Instruct Sentry that this install intends to be run by a single organization
      # and thus various UI optimizations should be enabled.
      SENTRY_SINGLE_ORGANIZATION = True
      DEBUG = True
      SENTRY_OPTIONS["system.event-retention-days"] = int(
          env('SENTRY_EVENT_RETENTION_DAYS', '90')
      )
      
      SENTRY_OPTIONS["redis.clusters"] = {
          "default": {
              "hosts": {0: {"host": "${cfg.redisHost}", "password": "${(passwordFileOrPasswordOr "") cfg.redisPasswordFile cfg.redisPassword}", "port": "${toString cfg.redisPort}", "db": "0"}}
          }
      }

      #########
      # Cache #
      #########
      
      # Sentry currently utilizes two separate mechanisms. While CACHES is not a
      # requirement, it will optimize several high throughput patterns.
      
      # If you wish to use memcached, install the dependencies and adjust the config
      # as shown:
      #
      #   pip install python-memcached
      #
      # CACHES = {
      #     'default': {
      #         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
      #         'LOCATION': ['127.0.0.1:11211'],
      #     }
      # }
      CACHES = {
          "default": {
              "BACKEND": "django.core.cache.backends.memcached.MemcachedCache",
              "LOCATION": ["${cfg.memcachedHost}:${toString cfg.memcachedPort}"],
              "TIMEOUT": 3600,
          }
      }
      
      # A primary cache is required for things such as processing events
      SENTRY_CACHE = 'sentry.cache.redis.RedisCache'
      
      DEFAULT_KAFKA_OPTIONS = {
          "bootstrap.servers": "${cfg.kafkaHost}:${toString cfg.kafkaPort}",
          "message.max.bytes": 50000000,
          "socket.timeout.ms": 1000,
      }
      
      SENTRY_EVENTSTREAM = "sentry.eventstream.kafka.KafkaEventStream"
      SENTRY_EVENTSTREAM_OPTIONS = {"producer_configuration": DEFAULT_KAFKA_OPTIONS}
      
      KAFKA_CLUSTERS["default"] = DEFAULT_KAFKA_OPTIONS
      
      #########
      # Queue #
      #########
      
      # See https://docs.sentry.io/on-premise/server/queue/ for more
      # information on configuring your queue broker and workers. Sentry relies
      # on a Python framework called Celery to manage queues.
      
      BROKER_URL = "redis://:{password}@{host}:{port}/{db}".format(
          **SENTRY_OPTIONS["redis.clusters"]["default"]["hosts"][0]
      )
      
      ###############
      # Rate Limits #
      ###############
      
      # Rate limits apply to notification handlers and are enforced per-project
      # automatically.
      
      SENTRY_RATELIMITER = 'sentry.ratelimits.redis.RedisRateLimiter'
      
      ##################
      # Update Buffers #
      ##################
      
      # Buffers (combined with queueing) act as an intermediate layer between the
      # database and the storage API. They will greatly improve efficiency on large
      # numbers of the same events being sent to the API in a short amount of time.
      # (read: if you send any kind of real data to Sentry, you should enable buffers)
      
      SENTRY_BUFFER = 'sentry.buffer.redis.RedisBuffer'
      
      ##########
      # Quotas #
      ##########
      
      # Quotas allow you to rate limit individual projects or the Sentry install as
      # a whole.
      
      SENTRY_QUOTAS = 'sentry.quotas.redis.RedisQuota'
      
      ########
      # TSDB #
      ########
      
      # The TSDB is used for building charts as well as making things like per-rate
      # alerts possible.
      
      SENTRY_TSDB = 'sentry.tsdb.redissnuba.RedisSnubaTSDB'
      
      #########
      # SNUBA #
      #########
      
      SENTRY_SEARCH = 'sentry.search.snuba.EventsDatasetSnubaSearchBackend'
      SENTRY_SEARCH_OPTIONS = {}
      SENTRY_TAGSTORE_OPTIONS = {}
      SENTRY_SNUBA = "http://${cfg.snubaHost}:${toString cfg.snubaPort}"
      
      ###########
      # Digests #
      ###########
      
      # The digest backend powers notification summaries.
      
      SENTRY_DIGESTS = 'sentry.digests.backends.redis.RedisBackend'
      
      ##############
      # Web Server #
      ##############
      
      # If you're using a reverse SSL proxy, you should enable the X-Forwarded-Proto
      # header and uncomment the following settings
      # SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
      # SESSION_COOKIE_SECURE = True
      # CSRF_COOKIE_SECURE = True
      
      SENTRY_WEB_HOST = '${cfg.sentryHost}'
      SENTRY_WEB_PORT = ${toString cfg.sentryPort}
      SENTRY_WEB_OPTIONS = {
          # These ase for proper HTTP/1.1 support from uWSGI
          # Without these it doesn't do keep-alives causing
          # issues with Relay's direct requests.
          "http-keepalive": True,
          "http-chunked-input": True,
          # the number of web workers
          'workers': 3,
          # Turn off memory reporting
          "memory-report": False,
          # Some stuff so uwsgi will cycle workers sensibly
          'max-requests': 100000,
          'max-requests-delta': 500,
          'max-worker-lifetime': 86400,
          # Duplicate options from sentry default just so we don't get
          # bit by sentry changing a default value that we depend on.
          'thunder-lock': True,
          'log-x-forwarded-for': False,
          'buffer-size': 32768,
          'limit-post': 209715200,
          'disable-logging': True,
          'reload-on-rss': 600,
          'ignore-sigpipe': True,
          'ignore-write-errors': True,
          'disable-write-exception': True,
      }
      
      ############
      # Features #
      ############
      
      SENTRY_FEATURES["projects:sample-events"] = True 
      SENTRY_FEATURES.update(
          {
              feature: True
              for feature in (
                  "organizations:discover",
                  "organizations:events",
                  "organizations:global-views",
                  "organizations:integrations-issue-basic",
                  "organizations:integrations-issue-sync",
                  "organizations:invite-members",
                  "organizations:sso-basic",
                  "organizations:sso-rippling",
                  "organizations:sso-saml2",
                  "projects:custom-inbound-filters",
                  "projects:data-forwarding",
                  "projects:discard-groups",
                  "projects:plugins",
                  "projects:rate-limits",
                  "projects:servicehooks",
              )
          }
      )
      
      ######################
      # GitHub Integration #
      ######################
      
      GITHUB_EXTENDED_PERMISSIONS = ['repo']
      '';
    in
    {
      environment.etc = {
        "sentry/config.yml".target = sentryConfigYml;
        "sentry/sentry.conf.py".target = sentryConfPy;
      };

      systemd.services.sentry-web = {
        description = "Sentry web server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "memcached.service" "postgresql.service" "apache-kafka.service" "redis.service" "snuba.service" ];

        serviceConfig = {
          Environment="SENTRY_CONF=/etc/sentry";
          ExecStart="${cfg.package}/bin/sentry run web";
        };
      };

      systemd.services.sentry-worker = {
        description = "Sentry worker";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "memcached.service" "postgresql.service" "apache-kafka.service" "redis.service" "snuba.service" ];

        serviceConfig = {
          Environment="SENTRY_CONF=/etc/sentry";
          ExecStart="${cfg.package}/bin/sentry run worker";
        };
      };

      systemd.services.sentry-cron = {
        description = "Sentry cron to remove old events";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "memcached.service" "postgresql.service" "apache-kafka.service" "redis.service" "snuba.service" ];

        serviceConfig = {
          Environment="SENTRY_CONF=/etc/sentry";
          ExecStart="${cfg.package}/bin/sentry run cron";
        };
      };

      systemd.services.sentry.preStart = ''
        set -eu
  
        SENTRY_CONF=/etc/sentry sentry upgrade
      '';
  
      environment.systemPackages = with pkgs; [
        uwsgiWithPython
      ];
    };
}
