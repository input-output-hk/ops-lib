{ ... }: {
  imports = [ ./common.nix ];
  deployment.packet.plan = "c1.small.x86";
}
