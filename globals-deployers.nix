self: super: {
  globals = rec {
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
