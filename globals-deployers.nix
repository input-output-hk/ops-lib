self: super: {
  globals = rec {
    deploymentName = "deployers";
    nixops-plugins = [ "nixops-aws" ];
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
