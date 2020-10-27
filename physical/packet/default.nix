{
  targetEnv = "packet";
  c1-cpr-small = import ./c1-cpr.small.nix;
  c1-small = import ./c1.small.nix;
  c2-cpr-reserved-medium = import ./c2-cpr-reserved.medium.nix;
  c2-cpr-medium = import ./c2-cpr.medium.nix;
  c2-medium = import ./c2.medium.nix;
  s1-large = import ./s1.large.nix;
  t1-small = import ./t1.small.nix;
  t3-small = import ./t3.small.nix;
}
