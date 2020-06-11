{ pkgs, lib, config, ... }:
let
  cfg = config.services.prometheus.exporters.systemd;

  inherit (lib)
    mkIf concatStringsSep mkOption mkEnableOption cli replaceStrings;
  inherit (lib.types) nullOr listOf str enum port;
in {
  options.services.prometheus.exporters.systemd = {
    enable = mkEnableOption "Enable the systemd exporter";

    unitWhitelist = mkOption {
      type = nullOr (listOf str);
      default = null;
    };

    unitBlacklist = mkOption {
      type = nullOr (listOf str);
      default = null;
    };

    logLevel = mkOption {
      type = enum [ "panic" "fatal" "error" "warning" "info" "debug" "trace" ];
      default = "info";
    };

    host = mkOption {
      type = str;
      default = "0.0.0.0";
    };

    port = mkOption {
      type = port;
      default = 9558;
    };

    exporterMetrics = mkEnableOption "Export metrics about itself";
    enableFileDescriptorSize = mkEnableOption "Export file descriptor metrics";
  };

  config = mkIf cfg.enable {
    systemd.services.systemd-exporter = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.service" ];

      serviceConfig.ExecStart = let
        escape = replaceStrings [ "." ] [ "\\." ];
        flags = cli.toGNUCommandLineShell { } {
          "collector.unit-whitelist" = if (cfg.unitWhitelist == null) then
            null
          else
            concatStringsSep "|" (map escape cfg.unitWhitelist);
          "collector.unit-blacklist" = if (cfg.unitBlacklist == null) then
            null
          else
            concatStringsSep "|" (map escape cfg.unitBlacklist);
          "log.level" = cfg.logLevel;
          "web.disable-exporter-metrics" = !cfg.exporterMetrics;
          "collector.enable-restart-count" = true;
          "web.listen-address" = "${cfg.host}:${toString cfg.port}";
          "collector.enable-file-descriptor-size" =
            cfg.enableFileDescriptorSize;
        };
      in "${pkgs.systemd-exporter}/bin/systemd_exporter ${flags}";

      serviceConfig.Restart = "always";
    };
  };
}
