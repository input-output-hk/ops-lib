{ pkgs, lib, ... }: {
  imports = [ ./common.nix ];
  deployment.ec2.instanceType = "m5.8xlarge";
  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
}
