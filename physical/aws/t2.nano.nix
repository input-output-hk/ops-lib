{ ... }: {
  imports = [ ./. ];
  deployment.ec2.instanceType = "t2.nano";
}
