self: super: {
  mergeSources = super: s: {
    sources = (super.sources or s) // s;
  };

  iohk-ops-lib = {
    physical = import ../physical;
    roles = import ../roles;
    modules = import ../modules;
  };

}
