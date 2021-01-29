{
  description = "Utilities for ops and packaging nix";

  outputs = { self, nixpkgs }: let

      # This is meant to make it easy to create hydraJobs with flakes
      # the two issues with numtide-flakeutils, is that it will create the packages
      # at the wrong attr path. E.g. hydraJobs.x86_64-linux.package. And the
      # other issue is that it also makes it hard to scope the jobs to
      # only as subset of platforms.
      #
      # Example usage:
      #
      #  let
      #    pkgsForSystem = system: (import nixpkgs) { inherit system; overlays = [
      #      (import ./nix/overlay.nix)
      #    ];};
      #    hydraUtils = ops-lib.lib.mkHydraUtils pkgsForSystem;
      #    inherit (hydraUtils) collectHydraSets mkHydraSet;
      #  in (collectHydraSets [
      #    (mkHydraSet [ "mantis-docker" ] [ "x86_64-linux" ])
      #    (mkHydraSet [ "mantis" "mantis-explorer" ] [ "x86_64-linux" "x86_64-darwin" ])
      #  ])
      #
      #  This flake will evaluate to:
      #    { hydraJobs = {
      #        mantis.x86_64-linux = <drv>;
      #        mantis.x86_64-darwin = <drv>;
      #        mantis-explorer.x86_64-linux = <drv>;
      #        mantis-explorer.x86_64-darwin = <drv>;
      #        mantis-docker.x86_64-linux = <drv>;
      #    };}
      mkHydraUtils = mkPkgs: let
        # nothing in lib should really depend on the system
        libPkgs = mkPkgs "x86_64-linux";
        # [attrset] -> attrset
        recursiveMerge = libPkgs.lib.foldr libPkgs.lib.recursiveUpdate {};
        mkHydraJobsForSystem = attrs: system:
            recursiveMerge (map (n: { "${n}"."${system}" = (mkPkgs system)."${n}"; }) attrs);
      in {
        collectHydraSets = jobSets: { hydraJobs = recursiveMerge jobSets; };
        mkHydraSet = attrs: systems: recursiveMerge (map (mkHydraJobsForSystem attrs) systems);
      };
    in {
      lib = { inherit mkHydraUtils; };
    };
}
