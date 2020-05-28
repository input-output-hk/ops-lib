{ pkgs , config , ... }:

{
  name = "sentry-module-test";

  nodes = {
    machine = { lib, config, pkgs, ... }: {
      imports = [
        ../modules/sentry/module.nix
      ];

      virtualisation.memorySize = 2048;
      virtualisation.diskSize   = 2048;
    };
  };

  testScript = ''
  '';
}
