{
  targetEnv = "ec2";

  t2-nano = import ./t2.nano.nix;
  t2-large = import ./t2.large.nix;
  t2-xlarge = import ./t2.xlarge.nix;

  t3a-small = import ./t3a.small.nix;
  t3a-medium = import ./t3a.medium.nix;
  t3a-large = import ./t3a.large.nix;
  t3a-xlarge = import ./t3a.xlarge.nix;
  t3a-xlargeMonitor = import ./t3a.xlarge-monitor.nix;
  t3a-2xlarge = import ./t3a.2xlarge.nix;

  security-groups = import ./security-groups;
}
