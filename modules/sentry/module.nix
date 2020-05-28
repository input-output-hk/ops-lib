{ config, pkgs, lib, ... }: 

with lib;

let
  cfg = config.services.sentry;
in

{
  imports = [];

  options.services.sentry = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
  };
}
