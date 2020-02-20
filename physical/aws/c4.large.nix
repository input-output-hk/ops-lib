{ ... }: {
  imports = [ ./common.nix ];
  deployment.ec2.instanceType = "c4.large";
}
