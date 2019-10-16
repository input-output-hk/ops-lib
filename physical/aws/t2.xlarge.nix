
{ ... }: {
  imports = [ ./common.nix ];
  deployment.ec2.instanceType = "t2.xlarge";
}
