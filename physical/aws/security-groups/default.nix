{
  allow-all = import ./allow-all.nix;
  allow-deployer-ssh = import ./allow-deployer-ssh.nix;
  allow-monitoring-collection = import ./allow-monitoring-collection.nix;
  allow-public-www-https = import ./allow-public-www-https.nix;
  allow-ssh = import ./allow-ssh.nix;
  allow-graylog = import ./allow-graylog.nix;
}
