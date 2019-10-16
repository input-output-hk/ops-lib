{ callPackage
, lib
, iohk-ops-lib
, targetEnv
, tiny, large
, ...
}:
let

  inherit (lib) recursiveUpdate mapAttrs;
  inherit (iohk-ops-lib) roles modules;

  mkNode = args:
    recursiveUpdate {
      imports = args.imports ++ [ modules.common ];
      deployment.targetEnv = targetEnv;
    } args;

  mkNodes = mapAttrs (_: mkNode);

  nodes = {
    monitoring = {
      imports = [ tiny ];
      deployment.ec2.region = "eu-central-1";
      deployment.packet.facility = "ams1";
      deployment.targetEnv = targetEnv;
    };
  };

in {
  network.description = "example-cluster";
  network.enableRollback = true;
} // nodes
