{ config, lib, ... }:

with lib;

let
  poolName = config.zfs.poolName;
in {
  options = {
    zfs.poolName = mkOption {
      type = types.str;
      default = "tank";
    };
  };
  imports = [
    #<nixpkgs/nixos/modules/virtualisation/amazon-init.nix>
  ];
  config = {
    boot = {
      # growPartition does not support zfs directly, so the above postDeviceCommands use what this puts into PATH
      growPartition = true;
      loader.grub.device = "/dev/xvda";
      zfs.devNodes = "/dev/";
      kernelParams = [ "console=ttyS0" ];
      initrd = {
        availableKernelModules = [ "virtio_pci" "virtio_blk" "xen-blkfront" "xen-netfront" ];
        postDeviceCommands = lib.mkMerge [
          (lib.mkBefore ''
            echo resizing xvda3
            TMPDIR=/run sh $(type -P growpart) "/dev/xvda" "3"
            udevadm settle
          '')
          # zfs mounts within postDeviceCommands so mkBefore and mkAfter must be used
          (lib.mkAfter ''
            echo expanding pool...
            zpool online -e ${poolName} /dev/xvda3
          '')
        ];
        network.enable = true;
        postMountCommands = ''
          metaDir=$targetRoot/etc/ec2-metadata
          mkdir -m 0755 -p "$metaDir"

          echo "getting EC2 instance metadata..."

          if ! [ -e "$metaDir/ami-manifest-path" ]; then
            wget -q -O "$metaDir/ami-manifest-path" http://169.254.169.254/1.0/meta-data/ami-manifest-path
          fi

          if ! [ -e "$metaDir/user-data" ]; then
            wget -q -O "$metaDir/user-data" http://169.254.169.254/1.0/user-data && chmod 600 "$metaDir/user-data"
          fi

          if ! [ -e "$metaDir/hostname" ]; then
            wget -q -O "$metaDir/hostname" http://169.254.169.254/1.0/meta-data/hostname
          fi

          if ! [ -e "$metaDir/public-keys-0-openssh-key" ]; then
            wget -q -O "$metaDir/public-keys-0-openssh-key" http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key
          fi
        '';
      };
    };
    fileSystems = {
      "/"     = { fsType = "zfs"; device = "${poolName}/root"; };
      "/home" = { fsType = "zfs"; device = "${poolName}/home"; };
      "/nix"  = { fsType = "zfs"; device = "${poolName}/nix"; };
      "/var"  = { fsType = "zfs"; device = "${poolName}/var"; };
    };
    networking = {
      hostName = lib.mkDefault "";
      # xen host on aws
      timeServers = [ "169.254.169.123" ];
    };
    services.openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
    };
  };
}
