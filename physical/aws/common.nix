{ name, config, resources, pkgs, lib, ... }:
let
  inherit (lib) mkDefault;
  inherit (config.deployment.ec2) region;

  inherit (pkgs.globals) ec2;
  inherit (ec2.credentials) accessKeyId;
  inherit (ec2) domain;
in {
  imports = [ ../../modules/aws.nix ];

  deployment.ec2 = {
    keyPair = mkDefault resources.ec2KeyPairs."${config.deployment.name}-${region}";

    ebsInitialRootDiskSize = mkDefault 30;

    elasticIPv4 = resources.elasticIPs."${name}-ip" or "";

    securityGroups = [
      resources.ec2SecurityGroups."allow-ssh-${region}"
      resources.ec2SecurityGroups."allow-monitoring-collection-${region}"
    ];
  };

  networking.hostName = mkDefault
    "${config.deployment.name}.${config.deployment.targetEnv}.${name}";

  deployment.route53 = lib.mkIf (config.node.fqdn != null) {
    inherit (config.node) accessKeyId;
    hostName = config.node.fqdn;
  };

  node = {
    inherit accessKeyId region;
    fqdn = "${name}.${domain}";
  };
}
