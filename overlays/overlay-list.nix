withRustOverlays: [
  ./packages.nix
  ./nixops.nix
  ./nginx-monitoring.nix
] ++ (if withRustOverlays then [ ./rust.nix ] else [])
