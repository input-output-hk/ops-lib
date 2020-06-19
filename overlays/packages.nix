self: super:
let
  inherit (self) callPackage;
in
{
  iohk-ops-lib = {
    physical = import ../physical;
    roles = import ../roles;
    modules = import ../modules;
    ssh-keys = import ./ssh-keys.nix self.lib;
    scripts = {
      gen-graylog-creds = import ../scripts/gen-graylog-creds.nix;
      gen-sentry-secret-key = import ../scripts/gen-sentry-secret-key.nix;
    };
  };

  sentry       = callPackage ../pkgs/sentry { };
  symbolicator = callPackage ../pkgs/symbolicator { };
  snuba        = callPackage ../pkgs/snuba { python = self.python37; };
  naersk       = callPackage self.sourcePaths.naersk {};
}
