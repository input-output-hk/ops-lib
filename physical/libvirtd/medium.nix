{ pkgs, ... }: {
  imports = [ ./common.nix ];
  deployment.libvirtd.memorySize = 2 * 1024;
}
