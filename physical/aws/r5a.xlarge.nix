{ pkgs, lib, ... }: {
  imports = [ ./common.nix ];
  deployment.ec2.instanceType = "r5a.xlarge";
  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
}
