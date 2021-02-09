{ pkgs, lib, config, nodes, resources,  ... }:
let

  inherit (pkgs.globals) static;
  inherit (lib) mapAttrs hasPrefix listToAttrs attrValues nameValuePair;

  mkMonitoredNodes = suffix:
    listToAttrs (attrValues
      (mapAttrs (name: node: nameValuePair "${name}${suffix}" {
        hasNginx = node.config.services.nginx.enable;
        hasVarnish = node.config.services.varnish.enable;
        applicationMonitoringPorts = node.config.services.monitoring-exporters.extraPrometheusExportersPorts;
      }) nodes));

  monitoredNodes = {
    ec2 = mkMonitoredNodes "-ip";
    libvirtd = mkMonitoredNodes "";
    packet = mkMonitoredNodes "";
  };

in {
  imports = [ ../modules/monitoring-services.nix ../modules/common.nix ];

  services.monitoring-services = {
    enable = true;
    webhost = config.node.fqdn;
    enableACME = config.deployment.targetEnv != "libvirtd";

    inherit (static)
      deadMansSnitch
      grafanaCreds
      graylogCreds
      oauth
      pagerDuty;

    monitoredNodes = monitoredNodes.${config.deployment.targetEnv};
  };

  services.elasticsearch.extraJavaOptions = [ "-Xms6g" "-Xmx6g" ];
}
