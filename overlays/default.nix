sourcePaths: withRustOverlays: map import (import ./overlay-list.nix withRustOverlays) ++
  [ (self: super: { inherit sourcePaths; })]
   ++ (if withRustOverlays then [ (import sourcePaths.nixpkgs-mozilla) ] else [])
