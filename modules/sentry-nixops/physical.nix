{
  redis = { ... }: {
    deployment.targetEnv = "libvirtd";
    deployment.libvirtd.headless = true;
  };

  memcached = { config, pkgs, ... }: {
    deployment.targetEnv = "libvirtd";
    deployment.libvirtd.headless = true;
  };

  clickhouse = { config, pkgs, ... }: {
    deployment.targetEnv = "libvirtd";
    deployment.libvirtd.headless = true;
  };
}
