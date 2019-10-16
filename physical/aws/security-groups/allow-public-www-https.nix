{ region, accessKeyId, ... }: {
  "allow-public-www-https-${region}" = {
    _file = ./allow-public-www-https.nix;
    inherit region accessKeyId;
    description = "WWW-http(s)";
    rules = [
      {
        protocol = "tcp";
        fromPort = 80;
        toPort = 80;
        sourceIp = "0.0.0.0/0";
      }
      {
        protocol = "tcp";
        fromPort = 443;
        toPort = 443;
        sourceIp = "0.0.0.0/0";
      }
    ];
  };
}
