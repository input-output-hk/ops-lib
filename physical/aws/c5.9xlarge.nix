{ pkgs, lib, ... }: {
  imports = [ ./common.nix ];
  deployment.ec2.instanceType = "c5.9xlarge";
  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
}
