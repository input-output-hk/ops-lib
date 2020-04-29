self: super: {
  globals = rec {
    deploymentName = "deployers";
    ec2 = {
      credentials = {
        accessKeyIds = {
          default = "root-account";
          "IOHK" = "root-account";
        };
      };
    };
  };
}
