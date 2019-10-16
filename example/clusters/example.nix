{ pkgs
, lib
, iohk-ops-lib
}:
{ targetEnv
, tiny, large
}:
let

  inherit (pkgs) sources;
  inherit (lib) recursiveUpdate mapAttrs;
  inherit (iohk-ops-lib) roles modules;

  nodes = {
    defaults = {
      imports = [ modules.common ];
      deployment.targetEnv = targetEnv;
      nixpkgs.overlays = pkgs.overlays;
    };

    monitoring = {
      imports = [ tiny ];
      deployment.ec2.region = "eu-central-1";
      deployment.packet.facility = "ams1";
    };
  };

in {
  network.description = "example-cluster";
  network.enableRollback = true;
} // nodes
