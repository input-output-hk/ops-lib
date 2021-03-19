let mkInstance = p: import p // {
  imports = [
    ./common.nix
    ({ config, ...}: {
      deployment.libvirtd.memorySize = config.node.memory * 1024;
      deployment.libvirtd.vcpu = config.node.cpus;
    })
  ];
}; in {
  targetEnv = "libvirtd";
  large = mkInstance ./large.nix;
  medium = mkInstance ./medium.nix;
  tiny = mkInstance ./tiny.nix;
}
