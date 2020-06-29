sourcePaths: map import (import ./overlay-list.nix) ++
  [(self: super: { inherit sourcePaths; })
   (import sourcePaths.nixpkgs-mozilla)
  ]
