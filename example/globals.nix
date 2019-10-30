self: super: {
  globals = {
    static = import ./static;
    domain = "example";
  };
}
