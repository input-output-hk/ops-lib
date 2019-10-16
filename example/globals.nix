self: super: {
  globals = {
    static = import ./static;
    domain = "example";
    applicationMonitoringPortsFor = name: node: [];
  };
}
