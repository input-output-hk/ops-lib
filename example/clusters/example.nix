pkgs:
{ targetEnv
, tiny, medium, large
}:
let

  inherit (pkgs) soursourcesPathsces lib iohk-ops-lib;
  inherit (lib) recursiveUpdate mapAttrs;
  inherit (iohk-ops-lib) roles modules;

  nodes = {
    defaults = { ... }: {
      imports = [ modules.common ];
      deployment.targetEnv = targetEnv;
      nixpkgs.overlays = import ../overlays sourcePaths;
    };

    monitoring = { ... }: {
      imports = [ tiny roles.monitor ];
      deployment.ec2.region = "eu-central-1";
      deployment.packet.facility = "ams1";
    };
  };

in {
  network.description = "example-cluster";
  network.enableRollback = true;
} // nodes
