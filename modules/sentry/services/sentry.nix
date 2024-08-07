{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.sentry;

  uwsgiWithPython =
    (pkgs.uwsgi.override { plugins = [ "python2" ]; }).overrideAttrs (oldDrv: {
      buildInputs = oldDrv.buildInputs ++ [ pkgs.makeWrapper ];

      installPhase = oldDrv.installPhase + ''
        runHook postInstall
      '';

      postInstall = (oldDrv.postInstall or "") + ''
        mv $out/bin/uwsgi $out/bin/uwsgi-wrapped
        makeWrapper "$out/bin/uwsgi-wrapped" "$out/bin/uwsgi" \
          --add-flags "--plugin $out/lib/uwsgi/python2_plugin.so"
      '';
    });

  surround = prefix: suffix: x: if x != null then prefix + x + suffix else null;

  or_ = a: b: if a != null then a else b;

in {
  options.services.sentry = {
    enable = mkEnableOption "Run the sentry suite of services.";

    package = mkOption {
      type = types.package;
      default = pkgs.sentry;
      example = literalExample "pkgs.sentry";
      description = ''
        The sentry package to use.
      '';
    };

    hostname = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        Hostname the Sentry web server should bind to.
      '';
    };

    eventRetentionDays = mkOption {
      type = types.int;
      default = 90;
      description = ''
        Sentry has a cleanup cron job the prunes events older than this many days.
      '';
    };

    dbName = mkOption {
      type = types.str;
      default = "sentrydb";
      description = ''
        Name of the Sentry database.
      '';
    };

    dbUser = mkOption {
      type = types.str;
      default = "sentry";
      description = ''
        Sentry database user name.
      '';
    };

    dbPasswordFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        Password file for the Sentrys postgresql database.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 9999;
      description = ''
        Port the Sentry web server should bind to.
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

    redisPasswordFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        Password file for the redis database.
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

    snubaHost = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Host snuba is runnion on.
      '';
    };

    snubaPort = mkOption {
      type = types.int;
      default = config.services.snuba.port;
      description = ''
        Port Snuba is running on.
      '';
    };

    snubaExtraCfg = mkOption {
      type = types.str;
      default = "";
      description = ''
        Extra snuba config.
      '';
    };

    memcachedPort = mkOption {
      type = types.int;
      default = config.services.memcached.port;
      description = ''
        Port memcached is running on.
      '';
    };

    memcachedHost = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Host memcached is running on.
      '';
    };

    symbolicatorHost = mkOption {
      type = types.str;
      default = config.services.symbolicator.host;
      description = ''
        Host symbolicator is running on.
      '';
    };

    symbolicatorPort = mkOption {
      type = types.int;
      default = config.services.symbolicator.port;
      description = ''
        Port symbolicator is running on.
      '';
    };

    googleAuth = mkOption {
      description = "Google Authentication";

      type = types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to use Google Authentication.
            '';
          };

          clientID = mkOption {
            type = types.str;
            description = ''
              Google Auth client ID.
            '';
          };

          clientSecret = mkOption {
            type = types.str;
            description = ''
              Google Auth client secret.
            '';
          };

          domains = mkOption {
            type = with types; listOf str;
            description = ''
              Users will be allowed to authenticate if they have an
              account under one of the Google Apps domains specified
              here.
            '';
          };
        };
      };
    };

    smtp = mkOption {
      description = "Mail";

      type = types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to enable SMTP.
            '';
          };

          host = mkOption {
            type = types.str;
            description = ''
              Hostname of SMTP server.
            '';
          };

          port = mkOption {
            type = types.int;
            description = ''
              Port of SMTP server.
            '';
          };

          username = mkOption {
            type = types.str;
            description = ''
              Username for SMTP server.
            '';
          };

          password = mkOption {
            type = types.str;
            description = ''
              Password for SMTP server.
            '';
          };

          useTLS = mkOption {
            type = types.bool;
            description = ''
              Whether to use TLS.
            '';
          };

          fromAddress = mkOption {
            type = types.str;
            description = ''
              The email address to send on behalf of.
            '';
          };
        };
      };
    };

  };

  config = let
    sentryConfigYml = ''
      ${if cfg.smtp.enable
        then ''
               mail.backend: 'smtp'
               mail.host: '${cfg.smtp.host}'
               mail.port: ${toString cfg.smtp.port}
               mail.username: '${cfg.smtp.username}'
               mail.password: '${cfg.smtp.password}'
               mail.use-tls: ${lib.boolToString cfg.smtp.useTLS}
               mail.from: '${cfg.smtp.fromAddress}'
             ''
        else "mail.backend: 'dummy'"
       }

      redis.clusters:
        default:
          hosts:
            0:
              host: ${cfg.redisHost}
              port: ${toString cfg.redisPort}

      filestore.backend: 'filesystem'
      filestore.options:
        location: '/tmp/sentry-files'

      symbolicator.enabled: true
      symbolicator.options:
        url: "http://${cfg.symbolicatorHost}:${toString cfg.symbolicatorPort}"
    '';

    sentryConfPy = ''
      # This file is just Python, with a touch of Django which means
      # you can inherit and tweak settings to your hearts content.
      from sentry.conf.server import *

      import os.path
      import os

      def readPasswordFile(file):
        with open(file, 'r') as fd:
          return fd.read()

      CONF_ROOT = os.path.dirname(__file__)

      DATABASES = {
          'default': {
              'ENGINE': 'sentry.db.postgres',
              'NAME': '${cfg.dbName}',
              'USER': '${cfg.dbUser}',
              'PASSWORD': ${or_ (surround "readPasswordFile(" ")" cfg.dbPasswordFile) "''"},
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
              "hosts": {0: { "host": "${cfg.redisHost}"
                           , "password": "${or_ (surround "readPasswordFile(" ")" cfg.redisPasswordFile) ""}"
                           , "port": "${toString cfg.redisPort}"
                           , "db": "0"
                           }
                       }
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
              "LOCATION": ["${cfg.memcachedHost}:${
                toString cfg.memcachedPort
              }"],
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

      SENTRY_WEB_HOST = '${cfg.hostname}'
      SENTRY_WEB_PORT = ${toString cfg.port}
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
          'disable-logging': False,
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

      secret_key = ${or_ (surround "readPasswordFile(" ")" "\"${cfg.secretKeyFile}\"") "None"}
      if not secret_key:
          raise Exception(
              "Error: SENTRY_SECRET_KEY is undefined, run `generate-secret-key` and set to -e SENTRY_SECRET_KEY"
          )

      if "SENTRY_RUNNING_UWSGI" not in os.environ and len(secret_key) < 32:
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
          print("!!                    CAUTION                       !!")
          print("!! Your SENTRY_SECRET_KEY is potentially insecure.  !!")
          print("!!    We recommend at least 32 characters long.     !!")
          print("!!     Regenerate with `generate-secret-key`.       !!")
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

      SENTRY_OPTIONS["system.secret-key"] = secret_key

      # Whitelist Symbolicator's request IP to fetch debug symbols from Sentry.
      # INTERNAL_SYSTEM_IPS = ["${cfg.symbolicatorHost}"]

      ${lib.optionalString cfg.googleAuth.enable ''
        SENTRY_OPTIONS['auth-google.client-id'] = "${cfg.googleAuth.clientID}"
        SENTRY_OPTIONS['auth-google.client-secret'] = "${cfg.googleAuth.clientSecret}"
      ''
      }
    '';

    sentryConfFolder = pkgs.runCommandLocal "sentry-conf"
      { inherit sentryConfigYml sentryConfPy;
        passAsFile = [ "sentryConfigYml" "sentryConfPy" ];
      }
      ''
        mkdir $out
        mv "$sentryConfigYmlPath" "$out/config.yml"
        mv "$sentryConfPyPath" "$out/sentry.conf.py"
      '';

  in mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.secretKeyFile != null;
        message =
          "sentry: A secret key is required, please specify secretKeyFile.";
      }
    ];

    users.groups.sentry = { };

    users.users.sentry = {
      description = "Sentry";
      group = "sentry";
    };

    environment.systemPackages = [ cfg.package sentryConfFolder ];

    services.cron = {
      enable = true;
      systemCronJobs = [
        "0 0 * * *      sentry    SENTRY_CONF=${sentryConfFolder} sentry cleanup --days ${toString cfg.eventRetentionDays}"
      ];
    };

    systemd.services = let
      common = {
        wantedBy = [ "multi-user.target" ];
        wants = [ "sentry-init.service" ];
        after = [ "network.target" "sentry-init.service" ];

        serviceConfig = {
          User = "sentry";
          Environment = "SENTRY_CONF=${sentryConfFolder}";
        };
      };
    in {
      sentry-web = lib.recursiveUpdate common {
        description = "Sentry web server";

        path = [ uwsgiWithPython ];

        serviceConfig.ExecStart = "${cfg.package}/bin/sentry run web";
      };

      sentry-worker = lib.recursiveUpdate common {
        description = "Sentry worker";

        serviceConfig.ExecStart = "${cfg.package}/bin/sentry run worker";
      };

      sentry-cron = lib.recursiveUpdate common {
        description = "Sentry cron to remove old events";

        serviceConfig.ExecStart = "${cfg.package}/bin/sentry run cron";
      };

      sentry-post-process-forwarder = lib.recursiveUpdate common {
        description = "Sentry post process forwarder task";

        serviceConfig.ExecStart =
          "${cfg.package}/bin/sentry run post-process-forwarder --commit-batch-size 1";
      };

      sentry-init = {
        description = "Setup sentry.";
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
          wait_for_open_port ${cfg.snubaHost} ${toString cfg.snubaPort}
          snuba=$?
          wait_for_open_port ${cfg.postgresqlHost} ${
            toString cfg.postgresqlPort
          }
          postgres=$?
          wait_for_open_port ${cfg.memcachedHost} ${toString cfg.memcachedPort}
          memcached=$?
          wait_for_open_port ${cfg.redisHost} ${toString cfg.redisPort}
          redis=$?
          wait_for_open_port ${cfg.symbolicatorHost} ${
            toString cfg.symbolicatorPort
          }
          symbolicator=$?


          if [ $kafka -eq 0 -a $snuba -eq 0 -a $postgres -eq 0 -a $memcached -eq 0 -a $redis -eq 0 -a $symbolicator -eq 0 ]
          then
            SENTRY_CONF=${sentryConfFolder} ${cfg.package}/bin/sentry upgrade --noinput

            echo ""
            echo "Did not prompt for user creation due to non-interactive shell."
            echo "Run the following command to create one yourself (recommended):"
            echo ""
            echo " SENTRY_CONF=${sentryConfFolder} sentry createuser"
            echo ""

            echo "Adding Google SSO domains to database..."
            ${optionalString (cfg.dbPasswordFile != null) "PGPASSFILE=${cfg.dbPasswordFile}"} \
            ${pkgs.postgresql}/bin/psql --host ${cfg.postgresqlHost} --port ${toString cfg.postgresqlPort} \
                                        --username ${cfg.dbUser} --dbname ${cfg.dbName} \
                                        -c "update sentry_authprovider set config = '{\"domains\": [${lib.concatMapStringsSep ", " (d: "\\\"" + d + "\\\"") cfg.googleAuth.domains}], \"version\": 1}' where provider = 'google';"
          else
            exit 1
          fi
        '';

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "sentry";
          Group = "sentry";
        };
      };
    };
  };
}
