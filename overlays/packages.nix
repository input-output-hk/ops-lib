self: super: {
  mkSourcesOverlay = s: {
    sources = (super.sources or s) // s;
  };
}
