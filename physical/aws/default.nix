pkgs: with pkgs;
let mkInstance = p: let i = import p { inherit pkgs lib; }; in lib.recursiveUpdate i {
    # those data need to be available without the module system:
    node = {
      cpus = aws-instances.${i.deployment.ec2.instanceType}.vCPU;
      inherit (aws-instances.${i.deployment.ec2.instanceType}) memory;
    };
  };
in {
  targetEnv = "ec2";

  t2-nano = mkInstance ./t2.nano.nix;
  t2-large = mkInstance ./t2.large.nix;
  t2-xlarge = mkInstance ./t2.xlarge.nix;

  t3-xlarge = mkInstance ./t3.xlarge.nix;
  t3-2xlargeMonitor = mkInstance ./t3.2xlarge-monitor.nix;

  t3a-nano = mkInstance ./t3a.nano.nix;
  t3a-small = mkInstance ./t3a.small.nix;
  t3a-medium = mkInstance ./t3a.medium.nix;
  t3a-large = mkInstance ./t3a.large.nix;
  t3a-xlarge = mkInstance ./t3a.xlarge.nix;
  t3a-xlargeMonitor = mkInstance ./t3a.xlarge-monitor.nix;
  t3a-2xlarge = mkInstance ./t3a.2xlarge.nix;

  c4-large = mkInstance ./c4.large.nix;

  c5-2xlarge = mkInstance ./c5.2xlarge.nix;
  c5-4xlarge = mkInstance ./c5.4xlarge.nix;

  m5-xlarge = mkInstance ./m5.xlarge.nix;

  m5ad-xlarge = mkInstance ./m5ad.xlarge.nix;
  m5ad-4xlarge = mkInstance ./m5ad.4xlarge.nix;

  r5-xlarge = mkInstance ./r5.xlarge.nix;

  r5a-xlarge = mkInstance ./r5a.xlarge.nix;

  security-groups = import ./security-groups;

}
