self: super: {
  iohk-ops-lib = {
    physical = import ../physical;
    roles = import ../roles;
    modules = import ../modules;
    ssh-keys = import ./ssh-keys.nix self.lib;
    scripts = {
      gen-graylog-creds = import ../scripts/gen-graylog-creds.nix;
    };
  };

  naersk = self.callPackage self.sourcePaths.naersk {};

}
