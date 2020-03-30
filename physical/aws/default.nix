{
  targetEnv = "ec2";

  t2-nano = import ./t2.nano.nix;
  t2-large = import ./t2.large.nix;
  t2-xlarge = import ./t2.xlarge.nix;

  t3-xlarge = import ./t3.xlarge.nix;

  t3a-nano = import ./t3a.nano.nix;
  t3a-small = import ./t3a.small.nix;
  t3a-medium = import ./t3a.medium.nix;
  t3a-large = import ./t3a.large.nix;
  t3a-xlarge = import ./t3a.xlarge.nix;
  t3a-xlargeMonitor = import ./t3a.xlarge-monitor.nix;
  t3a-2xlarge = import ./t3a.2xlarge.nix;

  c4-large = import ./c4.large.nix;

  c5-2xlarge = import ./c5.2xlarge.nix;
  c5-4xlarge = import ./c5.4xlarge.nix;

  m5-xlarge = import ./m5.xlarge.nix;

  m5ad-xlarge = import ./m5ad.xlarge.nix;

  r5-xlarge = import ./r5.xlarge.nix;

  r5a-xlarge = import ./r5a.xlarge.nix;

  security-groups = import ./security-groups;
}
