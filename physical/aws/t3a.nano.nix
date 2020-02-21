{ pkgs, lib, ... }: {
  imports = [ ./common.nix ];
  deployment.ec2.instanceType = "t3a.nano";
  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
}
