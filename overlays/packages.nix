self: super: {
  mergeSources = super: s: {
    sources = (super.sources or s) // s;
  };
}
