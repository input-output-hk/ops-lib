{ name, config, resources, pkgs, lib, ... }:
let
  inherit (pkgs) aws-instances;
  inherit (lib) mkDefault;
  inherit (config.deployment.ec2) region;

  inherit (pkgs.globals) ec2 domain;
  inherit (ec2.credentials) accessKeyIds;
  accessKeyId = accessKeyIds.${config.node.org};
in {
  imports = [ ../../modules/aws.nix ];

  deployment.ec2 = {

    inherit (config.node) accessKeyId;

    ebsInitialRootDiskSize = mkDefault 30;

    elasticIPv4 = resources.elasticIPs."${name}-ip" or "";

  };

  deployment.route53 = lib.mkIf (config.node.fqdn != null) {
    accessKeyId = accessKeyIds.dns or config.node.accessKeyId;
    hostName = config.node.fqdn;
  };

  node = {
    cpus = aws-instances.${config.deployment.ec2.instanceType}.vCPU;
    inherit (aws-instances.${config.deployment.ec2.instanceType}) memory;
    inherit accessKeyId region;
    fqdn = "${name}.${domain}";
  };
}
