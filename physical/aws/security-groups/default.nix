rec {
  allow-all = import ./allow-all.nix;
  allow-deployer-ssh = import ./allow-deployer-ssh.nix;
  allow-monitoring-collection = import ./allow-monitoring-collection.nix;
  allow-public-www-https = import ./allow-public-www-https.nix;
  allow-ssh = allow-all-to-tcp-port "ssh" 22;
  allow-wireguard = allow-all-to-udp-port "wireguard" 17777;
  allow-graylog = allow-all-to-tcp-port "graylog" 5044;
  allow-all-to-tcp-port = import ./allow-all-to-tcp-port.nix;
  allow-all-to-udp-port = import ./allow-all-to-udp-port.nix;
  allow-to-tcp-port = import ./allow-to-tcp-port.nix;
}
