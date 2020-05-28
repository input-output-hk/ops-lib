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

      # Postgres database
      services.postgresql.enable = true;
      services.postgresql.package = pkgs.postgresql_11;

      # Redis
      services.redis.enable = true;
    };
  };

  testScript = ''
  '';
}
