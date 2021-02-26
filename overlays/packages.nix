self: super:
let
  inherit (self) callPackage lib;
in
{
  iohk-ops-lib = {
    physical = import ../physical;
    roles = import ../roles;
    modules = import ../modules;
    ssh-keys = import ./ssh-keys.nix lib;
    scripts = {
      gen-graylog-creds = import ../scripts/gen-graylog-creds.nix;
      gen-sentry-secret-key = import ../scripts/gen-sentry-secret-key.nix;
    };
  };

  sentry       = import ../pkgs/sentry { pkgs = self; };
  symbolicator = callPackage ../pkgs/symbolicator { };
  snuba        = import ../pkgs/snuba { pkgs = self; };
  naersk       = callPackage self.sourcePaths.naersk {};

  # grabed from https://raw.githubusercontent.com/vantage-sh/ec2instances.info/master/www/aws-instances.json
  aws-instances = builtins.listToAttrs (map (i: lib.nameValuePair i.instance_type i)
    (builtins.fromJSON (builtins.readFile ./aws-instances.json)));

}
