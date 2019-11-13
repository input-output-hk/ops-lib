pkgs:
{ targetEnv
, tiny
, medium
, large
}:
let

  inherit (pkgs) sourcePaths lib iohk-ops-lib;
  inherit (lib) recursiveUpdate mapAttrs;
  inherit (iohk-ops-lib) roles modules;

  nodes = {
    monitoring = mkNode {
      imports = [ tiny roles.monitor ];
      deployment.ec2.region = "eu-central-1";
      deployment.packet.facility = "ams1";
      node = {
        org = "default";
        roles.isMonitor = true;
      };
    };
  };

  mkNode = args:
    recursiveUpdate {
      deployment.targetEnv = targetEnv;
      nixpkgs.overlays = import ../overlays sourcePaths;
    } args;

in {
  network.description = "example-cluster";
  network.enableRollback = true;
} // nodes
