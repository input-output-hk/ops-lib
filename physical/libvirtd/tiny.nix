{ pkgs, ... }: {
  imports = [ ./common.nix ];
  deployment.libvirtd.memorySize = 512;
}
