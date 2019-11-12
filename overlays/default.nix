sourcePaths: map import (import ./overlay-list.nix) ++
  [(self: super: { inherit sourcePaths; })]
