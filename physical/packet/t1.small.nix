{ ... }: {
  imports = [ ./common.nix ];
  deployment.packet.plan = "t1.small.x86";
}
