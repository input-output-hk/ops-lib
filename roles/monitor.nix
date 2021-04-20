{ pkgs, lib, config, nodes, resources,  ... }:
let

  inherit (pkgs.globals) static;
  inherit (lib) attrNames filterAttrs attrValues mapAttrsToList groupBy' mkOption types concatMap;

  cfg = config.services.monitoring-services;

  nodeAddr = let
    suffix = {
      ec2 = "-ip";
      libvirtd = "";
      packet = "";
    }.${config.deployment.targetEnv};
    in name: "${name}${suffix}";

  scrapeConfigs = let
    nodeConfigs = concatMap
      (name: map (c: c // { inherit name;}) nodes.${name}.config.services.monitoring-exporters.extraPrometheusExporters)
      cfg.monitoredNodes;
    key = scrapeConfig: filterAttrs (_: v: v != null)
      (builtins.removeAttrs scrapeConfig ["_module" "name" "port" "labels"]);
    nodeStaticConfig = c: {
      targets = [ "${nodeAddr c.name}:${toString c.port}" ];
      labels = {
        alias = c.name;
        hostname = nodeAddr c.name;
        class = nodes.${c.name}.config.node.roles.class;
        cpus = toString nodes.${c.name}.config.node.cpus;
      } // (c.labels or {});
    };
  in attrValues (groupBy'
    (scrapeConfig: c: if (scrapeConfig == {})
      then (key c) // { static_configs = [(nodeStaticConfig c)]; }
      else scrapeConfig // { static_configs = scrapeConfig.static_configs ++ [(nodeStaticConfig c)]; }
    ) {} (c: builtins.toJSON (key c)) nodeConfigs);

in {
  imports = [ ../modules/monitoring-services.nix ../modules/common.nix ];
  options = {
    services.monitoring-services.monitoredNodes = mkOption {
      type = types.listOf types.str;
      default = attrNames (filterAttrs (_: node: node.config.services.monitoring-exporters.metrics) nodes);
      description = ''
        List of Nodes to be monitored, associated with their address.
        Default to all nodes with services.monitoring-exporters.metrics true.
      '';
      example = [ "c-a-1" ];
    };
  };
  config = {
    services.monitoring-services = {
      enable = true;
      webhost = config.node.fqdn;
      enableACME = config.deployment.targetEnv != "libvirtd";

      inherit (static)
        deadMansSnitch
        grafanaCreds
        graylogCreds
        pagerDuty;
    };

    services.oauth2_proxy.enable = lib.mkDefault true;

    services.prometheus = { inherit scrapeConfigs; };

    services.elasticsearch.extraJavaOptions = [ "-Xms6g" "-Xmx6g" ];
  };
}
