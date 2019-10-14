self: super: {
  mkSourcesOverlay = sourcesPath:
    let s = import sourcesPath; in
    {
      sources = (super.sources or s) // s;
    };
}
