{ ... }: {
  imports = [ ./common.nix ];
  deployment.packet.plan = "c2.medium.x86";
}
