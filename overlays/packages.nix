self: super: {
  mkSourcesOverlay = super: s: {
    sources = (super.sources or s) // s;
  };
}
