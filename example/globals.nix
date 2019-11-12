self: super: {
  globals = rec {
    static = import ./static;

    deploymentName = "example";

    domain = "${deploymentName}.aws.iohkdev.io";

    extraPrometheusExportersPorts = [];

    ec2 = {
      credentials = {
        accessKeyId = builtins.getEnv "AWS_ACCESS_KEY_ID";
      };
    };
  };
}
