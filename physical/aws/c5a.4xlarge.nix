{ pkgs, lib, ... }: {
  imports = [ ./common.nix ];
  deployment.ec2.instanceType = "c5a.4xlarge";
  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
}
