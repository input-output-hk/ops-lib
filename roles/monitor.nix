{ pkgs, lib, config, nodes, resources,  ... }:
let

  inherit (pkgs.globals) domain applicationMonitoringPortsFor;
  inherit (lib) mapAttrs hasPrefix listToAttrs attrValues nameValuePair;

  mkMonitoredNodes = suffix:
    listToAttrs (attrValues
      (mapAttrs (name: node: nameValuePair "${name}${suffix}" {
        hasNginx = node.config.services.nginx.enable;
        applicationMonitoringPorts = applicationMonitoringPortsFor name node;
      }) nodes));

  monitoredNodes = {
    ec2 = mkMonitoredNodes "-ip";
    libvirtd = mkMonitoredNodes "";
    packet = mkMonitoredNodes "";
  };

in {
  imports = [ ../modules/monitoring-services.nix ../modules/common.nix ];

  deployment.ec2.securityGroups = [
    resources.ec2SecurityGroups."allow-public-www-https-${config.node.region}"
  ];

  services.monitoring-services = {
    enable = true;
    webhost = config.node.fqdn;
    enableACME = config.deployment.targetEnv != "libvirtd";

    inherit (pkgs.secrets)
      deadMansSnitch
      grafanaCreds
      graylogCreds
      oauth
      pagerDuty;

    monitoredNodes = monitoredNodes.${config.deployment.targetEnv};
  };

  systemd.services.graylog.environment.JAVA_OPTS = ''
    -Djava.library.path=${pkgs.graylog}/lib/sigar -Xms3g -Xmx3g -XX:NewRatio=1 -server -XX:+ResizeTLAB -XX:+UseConcMarkSweepGC -XX:+CMSConcurrentMTEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC -XX:-OmitStackTraceInFastThrow
  '';

  services.elasticsearch.extraJavaOptions = [ "-Xms6g" "-Xmx6g" ];
}
