self: super:
let
  inherit (self) callPackage lib;
in
{
  iohk-ops-lib = {
    physical = import ../physical self;
    roles = import ../roles;
    modules = import ../modules;
    ssh-keys = import ./ssh-keys.nix lib;
    scripts = {
      gen-graylog-creds = import ../scripts/gen-graylog-creds.nix;
      gen-sentry-secret-key = import ../scripts/gen-sentry-secret-key.nix;
    };
  };

  naersk       = callPackage self.sourcePaths.naersk {};

  # grabed from https://raw.githubusercontent.com/vantage-sh/ec2instances.info/master/www/aws-instances.json
  aws-instances = builtins.listToAttrs (map (i: lib.nameValuePair i.instance_type i)
    (builtins.fromJSON (builtins.readFile ./aws-instances.json)));

  # workaround https://github.com/NixOS/nixpkgs/issues/47900
  awscli2 = (super.awscli2.overrideAttrs (old: {
    makeWrapperArgs = (old.makeWrapperArgs or []) ++ ["--unset" "PYTHONPATH"];
  }));

  mkBlackboxScrapeConfig = job_name: module: targets: {
    inherit job_name;
    scrape_interval = "60s";
    metrics_path = "/probe";
    params = { inherit module; };
    static_configs = [ { inherit targets; } ];
    relabel_configs = [
      {
        source_labels = [ "__address__" ];
        target_label = "__param_target";
      }
      {
        source_labels = [ "__param_target" ];
        target_label = "instance";
      }
      {
        replacement = "127.0.0.1:9115";
        target_label = "__address__";
      }
    ];
  };

}
