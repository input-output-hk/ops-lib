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

  sentry       = import ../pkgs/sentry { pkgs = self; };
  symbolicator = callPackage ../pkgs/symbolicator { };
  snuba        = import ../pkgs/snuba { pkgs = self; };
  naersk       = callPackage self.sourcePaths.naersk {};
}
