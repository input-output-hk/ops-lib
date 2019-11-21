{ region, org, pkgs, ... }: {
  "allow-monitoring-collection-${region}-${org}" = { nodes, resources, lib, ... }:
    let monitoringSourceIp = resources.elasticIPs.monitoring-ip;
    in {
      inherit region;
      accessKeyId = pkgs.globals.ec2.credentials.accessKeyIds.${org};
      _file = ./allow-monitoring-collection.nix;
      description = "Monitoring collection";
      rules = lib.optionals (nodes ? "monitoring") map (p:
        {
          protocol = "tcp";
          fromPort = p;
          toPort = p; # prometheus exporters
          sourceIp = monitoringSourceIp;
        }) ([
          8080  # explorer exporter
          9100  # prometheus exporters
          9102  # statd exporter
          9113  # nginx exporter
          12798 # haskell prometheus exporter
        ] ++ (pkgs.globals.extraPrometheusExportersPorts or []));
    };
}
