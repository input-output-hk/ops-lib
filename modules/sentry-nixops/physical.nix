{
  defaults = {
    # deployment.targetEnv = "libvirtd";
    # deployment.libvirtd.headless = true;

    deployment.targetEnv = "virtualbox";
    deployment.virtualbox.headless = true; # megabytes
    deployment.virtualbox.memorySize = 1024; # megabytes
    deployment.virtualbox.vcpu = 2; # number of cpus
  };
}
