{ config, pkgs, ... }: {
  imports = [ ./common.nix ];
  services.zfs.trim.enable = true;
  systemd.services.zfs-config = {
    path = with pkgs; [ zfs ];
    script = ''
      zfs set compression=lz4 zpool
    '';
    wantedBy = [ "multi-user.target" ];
  };
  boot.kernelParams = [
    "zfs.zfs_arc_max=${toString (1024*1024*1024*10)}"
  ];
  deployment.packet = {
    plan = "c2.medium.x86";
    customData = {
      cpr_storage = {
        disks = [
          {
            device = "/dev/disk/by-packet-category/boot0";
            partitions = [
              {
                label = "BIOS";
                number = 1;
                size = "512M";
              }
              {
                label = "SWAP";
                number = 2;
                size = "3993600";
              }
              {
                label = "ROOT";
                number = 3;
                size = 0;
              }
            ];
          }
        ];
        filesystems = [
          {
            mount = {
              device = "/dev/disk/by-packet-category/boot0-part1";
              format = "vfat";
              point = "/boot";
              create = {
                options = [
                  "32"
                  "-n"
                  "EFI"
                ];
              };
            };
          }
          {
            mount = {
              device = "/dev/disk/by-packet-category/boot0-part2";
              format = "swap";
              point = "none";
              create = {
                options = [
                  "-L"
                  "SWAP"
                ];
              };
            };
          }
        ];
      };

      cpr_zfs = {
        pools = {
          zpool = {
            pool_properties = {
            };
            vdevs = [
              {
                disk = [
                  "/dev/disk/by-packet-category/storage0"
                  "/dev/disk/by-packet-category/storage1"
                  "/dev/disk/by-packet-category/boot1"
                  "/dev/disk/by-packet-category/boot0-part3"
                ];
              }
            ];
          };
        };
        datasets = {
          "zpool/root" = {
            properties = {
              mountpoint = "legacy";
            };
          };
          "zpool/nix" = {
            properties = {
              mountpoint = "legacy";
            };
          };
          "zpool/home" = {
            properties = {
              mountpoint = "legacy";
            };
          };
          "zpool/var" = {
            properties = {
              mountpoint = "legacy";
            };
          };
          "zpool/cache" = {
            properties = {
              mountpoint = "legacy";
            };
          };
          "zpool/containers" = {
            properties = {
              mountpoint = "legacy";
            };
          };
          "zpool/docker" = {
            properties = {
              mountpoint = "legacy";
            };
          };
        };
        mounts = [
          {
            dataset = "zpool/root";
            point = "/";
          }
          {
            dataset = "zpool/nix";
            point = "/nix";
          }
          {
            dataset = "zpool/var";
            point = "/var";
          }
          {
            dataset = "zpool/cache";
            point = "/cache";
          }
          {
            dataset = "zpool/containers";
            point = "/var/lib/containers";
          }
          {
            dataset = "zpool/docker";
            point = "/var/lib/docker";
          }
          {
            dataset = "zpool/home";
            point = "/home";
          }
        ];
      };
    };
  };
}
