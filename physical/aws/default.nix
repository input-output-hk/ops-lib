{
  targetEnv = "ec2";

  t2large = import ./t2.large.nix;
  t2nano = import ./t2.nano.nix;
  t2xlarge = import ./t2.xlarge.nix;
  t3xlarge = import ./t3.xlarge.nix;

  security-groups = import ./security-groups;
}
