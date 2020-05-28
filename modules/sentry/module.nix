{ config, pkgs, lib, ... }: 

with lib;

let
  cfg = config.services.sentry;
in

{
  imports = [];

  options.services.sentry = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    secretKeyFile = mkOption {
      type = types.path;
      description = ''
        Path to file containing the secret key Sentry should use.
        Generate one with "sentry config generate-secret-key"
      '';
    };

    redisPort = mkOption {
      type = types.int;
      default = config.services.redis.port;
      description = ''
        Port Redis is running on.
      '';
    };

    postgresqlPort = mkOption {
      type = types.int;
      default = config.services.postgresql.port;
      description = ''
        Port Postgresql is running on.
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
              host: 127.0.0.1
              port: 6379
      filestore.backend: 'filesystem'
      filestore.options:
        location: '/tmp/sentry-files'
      '';

      sentryConfPy = pkgs.writeText "sentry.conf.py" ''
      # This file is just Python, with a touch of Django which means
      # you can inherit and tweak settings to your hearts content.
      from sentry.conf.server import *
      
      import os.path
      
      CONF_ROOT = os.path.dirname(__file__)
      
      DATABASES = {
          'default': {
              'ENGINE': 'sentry.db.postgres',
              'NAME': 'sentry',
              'USER': 'postgres',
              'PASSWORD': '',
              'HOST': '127.0.0.1',
              'PORT': '',
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
      DEBUG = False
      
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
      
      # A primary cache is required for things such as processing events
      SENTRY_CACHE = 'sentry.cache.redis.RedisCache'
      
      #########
      # Queue #
      #########
      
      # See https://docs.sentry.io/on-premise/server/queue/ for more
      # information on configuring your queue broker and workers. Sentry relies
      # on a Python framework called Celery to manage queues.
      
      BROKER_URL = 'redis://localhost:${cfg.redisPort}'
      
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
      
      SENTRY_TSDB = 'sentry.tsdb.redis.RedisTSDB'
      
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
      
      SENTRY_WEB_HOST = '0.0.0.0'
      SENTRY_WEB_PORT = 9000
      SENTRY_WEB_OPTIONS = {
          # 'workers': 1,  # the number of web workers
          # 'protocol': 'uwsgi',  # Enable uwsgi protocol instead of http
      }
      '';
    in
    {
    systemd.services.postgresql.postStart = ''
      set -eu

      SENTRY_CONF=/etc/sentry sentry upgrade

      $PSQL 
    '';
  };
}
