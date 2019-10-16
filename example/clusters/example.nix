pkgs:
{ targetEnv
, tiny, large
}:
let

  inherit (pkgs) sources lib iohk-ops-lib;
  inherit (lib) recursiveUpdate mapAttrs;
  inherit (iohk-ops-lib) roles modules;

  nodes = {
    defaults = { ... }: {
      network.firewall.enable = false;
      #imports = [ modules.common ];
      deployment.targetEnv = targetEnv;
      #nixpkgs.overlays = import ../overlays sources;
      boot.kernelParams = [ "console=ttyS0,115200" ];
      deployment.libvirtd.extraDevicesXML = ''
        <serial type='pty'>
          <target port='0'/>
        </serial>
        <console type='pty'>
          <target type='serial' port='0'/>
        </console>
      '';
    };

    monitoring = { ... }: {
      imports = [ large ];
      deployment.ec2.region = "eu-central-1";
      deployment.packet.facility = "ams1";
    };
  };

in {
  network.description = "example-cluster";
  network.enableRollback = true;
} // nodes
