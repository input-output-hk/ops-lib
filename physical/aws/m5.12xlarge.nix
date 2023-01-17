{ pkgs, lib, ... }: {
  imports = [ ./common.nix ];
  deployment.ec2.instanceType = "m5.12xlarge";
  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
}
