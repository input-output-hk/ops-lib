{ pkgs, ... }: {
  imports = [ ./common.nix ];
  deployment.libvirtd.memorySize = 1024 * 10;
}
