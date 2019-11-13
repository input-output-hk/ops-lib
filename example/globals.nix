self: super: {
  globals = rec {

    deployerIp = "127.0.0.1";

    static = import ./static;

    deploymentName = "example";

    domain = "${deploymentName}.aws.iohkdev.io";

    extraPrometheusExportersPorts = [];

    ec2 = {
      credentials = {
        accessKeyIds = {
          default = "default";
        };
      };
    };
  };
}
