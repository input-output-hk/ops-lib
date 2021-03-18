{ config, options, pkgs, lib, name, ... }:

with lib;

let
  cfg = config.services.monitoring-exporters;
  extraExporterOpts = {
    options =
      # We resuse options defined in services.prometheus.scrapeConfigs, in a somewhat hacky way...
      let scrapeConfigOpts = (builtins.head (builtins.head options.services.prometheus.scrapeConfigs.type.functor.wrapped.getSubModules).imports).options;
      in removeAttrs scrapeConfigOpts ["static_configs"] // {
        port = mkOption {
          type = types.int;
          default = 80;
          description = ''
            Monitoring target port.
          '';
        };
        labels = mkOption {
          type = types.attrsOf types.str;
          default = {};
          description = ''
            Labels assigned to all metrics scraped from the targets.
          '';
        };
      };
  };

in {

  options = {
    services.monitoring-exporters = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable monitoring exporters.  Metrics exporters are
          prometheus, statsd and nginx by default.  Log exporting is
          available via journalbeat by default.
          Metrics export can be selectively disabled with the metrics option.
          Log export be selectively disabled with the logging option.
        '';
      };

      metrics = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = ''
          Enable metrics exporters via prometheus, statsd
          and nginx.
          See also the corresponding metrics server option in
          the monitoring-services.nix module:
          config.services.monitoring-services.metrics
        '';
      };

      statsdPort = mkOption {
        type = types.int;
        default = 8125;
        description = ''
          Local statsd listenning port.
        '';
      };

      extraPrometheusExportersPorts = mkOption {
        type = types.listOf types.int;
        default = [];
        apply = list: [ 9100 9102 ] ++ list;
        description = ''
          Ports of application specific prometheus exporters.
        '';
      };

      extraPrometheusExporters = mkOption {
        default = [];
        type = with types; listOf (submodule extraExporterOpts);
        apply = exporters: lib.optional (config.services.nginx.enable) {
            job_name = "nginx";
            scrape_interval = "5s";
            metrics_path = "/status/format/prometheus";
            port = 9113;
          } ++ lib.optional (config.services.varnish.enable) {
            job_name = "varnish";
            scrape_interval = "5s";
            port = 9131;
          } ++ map (port : {
            job_name = "node";
            scrape_interval = "10s";
            inherit port;
            }) cfg.extraPrometheusExportersPorts
          ++ exporters;
        description = ''
          A list of additional scrape configurations for this host.
        '';
        example = literalExample ''
          [
            {
              job_name = "netdata";
              scrape_interval = "60s";
              metrics_path = "/api/v1/allmetrics?format=prometheus";
              port = globals.netdataExporterPort;
            };
          ]
        '';
      };

      logging = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = ''
          Enable logging exporter via journalbeat to graylog.
          See also the corresponding logging server option in
          the monitoring-services.nix module:
          config.services.monitoring-services.logging
        '';
      };

      graylogHost = mkOption {
        type = types.str;
        example = "graylog:5044";
        description = ''
          The host port under which Graylog is externally reachable.
        '';
      };

      papertrail.enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable papertrail.
        '';
      };

      ownIp = mkOption {
        type = types.str;
        description =
          "the address a remote prometheus node will use to contact this machine";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (config.services.nginx.enable && cfg.metrics) {
      services.nginx = {
        appendHttpConfig = ''
          vhost_traffic_status_zone;
          server {
            listen 9113;
            location /status {
              vhost_traffic_status_display;
              vhost_traffic_status_display_format html;
            }
          }
        '';
      };
      networking.firewall.allowedTCPPorts = [ 9113 ];
    })

    (mkIf (config.services.varnish.enable && cfg.metrics) {
      services.prometheus.exporters.varnish = {
        enable = true;
        group = "varnish";
        instance = "/var/spool/varnish/${name}";
      };
      networking.firewall.allowedTCPPorts = [ 9131 ];
    })

    (mkIf cfg.metrics {
      systemd.services."statd-exporter" = {
        wantedBy = [ "multi-user.target" ];
        requires = [ "network.target" ];
        after = [ "network.target" ];
        serviceConfig.ExecStart =
          "${pkgs.prometheus-statsd-exporter}/bin/statsd_exporter --statsd.listen-udp=:${toString cfg.statsdPort} --web.listen-address=:9102";
      };

      services = {
        prometheus.exporters.node = {
          enable = true;
          enabledCollectors = [
            "systemd"
            "tcpstat"
            "conntrack"
            "diskstats"
            "entropy"
            "filefd"
            "filesystem"
            "loadavg"
            "meminfo"
            "netdev"
            "netstat"
            "stat"
            "time"
            "timex"
            "vmstat"
            "logind"
            "interrupts"
            "ksmd"
            "processes"
          ];
        };
      };
      networking.firewall.allowedTCPPorts = map (e: e.port) cfg.extraPrometheusExporters;
    })

    (mkIf cfg.logging {
      services.journalbeat = {
        enable = true;
        package = pkgs.journalbeat7;
        extraConfig = ''
          journalbeat:
            seek_position: cursor
            cursor_seek_fallback: tail
            write_cursor_state: true
            cursor_flush_period: 5s
            clean_field_names: true
            convert_to_numbers: false
            move_metadata_to_field: journal
            default_type: journal
          output.logstash:
            hosts: ["${cfg.graylogHost}"]
          journalbeat.inputs:
            - paths:
              - "/var/log/journal/"
        '';
      };
    })

    (mkIf cfg.papertrail.enable {
      systemd.services.papertrail = {
        description = "Papertrail.com log aggregation";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        script = ''
          ${pkgs.systemd}/bin/journalctl -f | ${pkgs.nmap}/bin/ncat --ssl logs5.papertrailapp.com 43689
        '';
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = "5s";
          TimeoutStartSec = 0;
          KillSignal = "SIGINT";
        };
      };
    })
  ]);
}
