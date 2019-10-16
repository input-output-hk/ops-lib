self: super: {
  mergeSources = super: s: {
    sources = (super.sources or s) // s;
  };

  iohk-ops-lib = {
    physical = import ../physical;
    roles = import ../roles;
    modules = import ../modules;
    ssh-keys = import ./ssh-keys.nix self.pkgs.lib;
  };

}
