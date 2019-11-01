{ name, config, resources, pkgs, lib, ... }:
let
  inherit (lib) mkDefault;
  inherit (config.deployment.ec2) region;

  inherit (pkgs.globals) ec2 domain;
  inherit (ec2.credentials) accessKeyId;
in {
  imports = [ ../../modules/aws.nix ];

  deployment.ec2 = {
    keyPair = mkDefault resources.ec2KeyPairs."${pkgs.globals.deploymentName}-${region}";

    accessKeyId = mkDefault accessKeyId;

    ebsInitialRootDiskSize = mkDefault 30;

    elasticIPv4 = resources.elasticIPs."${name}-ip" or "";

    securityGroups = [
      resources.ec2SecurityGroups."allow-ssh-${region}"
      resources.ec2SecurityGroups."allow-monitoring-collection-${region}"
    ];
  };

  deployment.route53 = lib.mkIf (config.node.fqdn != null) {
    inherit (config.node) accessKeyId;
    hostName = config.node.fqdn;
  };

  node = {
    inherit accessKeyId region;
    fqdn = "${name}.${domain}";
  };
}
