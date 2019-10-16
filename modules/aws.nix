{ lib, config, ... }:
with lib;
with types; {
  options = {
    node = mkOption {
      description = "Node-specific parameters.";
      default = { };

      type = submodule {
        options = {
          ##
          ## Mandatory configuration:
          region = mkOption {
            type = enum [
              "us-east-1" # US East (N. Virginia)
              "us-east-2" # US East (Ohio)
              "us-west-1" # US West (N. California)
              "us-west-2" # US West (Oregon)
              "ca-central-1" # Canada (Central)
              "eu-central-1" # EU (Frankfurt)
              "eu-west-1" # EU (Ireland)
              "eu-west-2" # EU (London)
              "eu-west-3" # EU (Paris)
              "eu-north-1" # EU (Stockholm)
              "ap-east-1" # Asia Pacific (Hong Kong)
              "ap-northeast-1" # Asia Pacific (Tokyo)
              "ap-northeast-2" # Asia Pacific (Seoul)
              "ap-northeast-3" # Asia Pacific (Osaka-Local)
              "ap-southeast-1" # Asia Pacific (Singapore)
              "ap-southeast-2" # Asia Pacific (Sydney)
              "ap-south-1" # Asia Pacific (Mumbai)
              "me-south-1" # Middle East (Bahrain)
              "sa-east-1" # South America (São Paulo)
            ];
            description = "Region.  Must be set (use deployments/config.nix).";
            default = "eu-central-1";
          };

          accessKeyId = mkOption {
            type = str;
            description = "Access key ID.";
            default = null;
          };

          fqdn = mkOption {
            type = nullOr str;
            description = "Node's FQDN.";
            default = null;
          };

          ##
          ## Non-mandatory configuration:
          instanceType = mkOption {
            type = str;
            description = "Instance type.";
            default = "t2.large";
          };

          org = mkOption {
            type = str;
            description = "Organisation.";
            default = "IOHK";
          };

          spotInstancePrice = mkOption {
            type = int;
            description =
              "Price (in dollar cents per hour) to use for spot instances request for the machine. If the value is equal to 0 (default), then spot instances are not used.";
            default = config.cluster.spotInstancePrice;
          };

          allocateElasticIP = mkOption {
            type = bool;
            description =
              "Node-specific EIP allocation override.  You must provide <name>-ip.";
            default = config.cluster.allocateElasticIP;
          };
        };
      };
    };

    cluster = mkOption {
      description = "Cluster-wide configuration.";
      default = { };

      type = submodule {
        options = {
          ##
          ## Mandatory configuration:
          name = mkOption {
            type = str;
            description = "Name of the cluster instance";
            default = null;
          };

          deployerIP = mkOption {
            type = str;
            description =
              "Deployer machine IP.  Must be set (use deployments/config.nix).";
            default = null;
          };

          generateLetsEncryptCert = mkOption {
            type = bool;
            description =
              "Use let's encrypt to generate a proper TLS certificate.";
            default = false;
          };

          tlsCert = mkOption {
            type = nullOr path;
            description =
              "Custom TLS cert. Will use ACME to generate one if null";
            default = null;
          };

          tlsCertKey = mkOption {
            type = nullOr path;
            description =
              "Custom TLS cert dir key. Will use ACME to generate one if null";
            default = null;
          };

          ##
          ## Non-mandatory configuration:
          toplevelDomain = mkOption {
            type = nullOr str;
            description = "Top level domain.  'null' for no DNS record.";
            default = if config.cluster.hostedZone != null then
              config.cluster.hostedZone
            else
              "iohk";
          };

          hostedZone = mkOption {
            type = nullOr str;
            description = "Hosted zone";
            default = null;
          };

          allocateElasticIP = mkOption {
            type = bool;
            description = "Cluster-wide EIP allocation policy.";
            default = false;
          };

          spotInstancePrice = mkOption {
            type = int;
            description =
              "Price (in dollar cents per hour) to use for spot instances request for the machine. If the value is equal to 0 (default), then spot instances are not used.";
            default = 0;
          };

          subDomain = mkOption {
            type = nullOr str;
            description = "Subdomain to use. Defaults to `cluster.name`.";
            default = config.cluster.name;
          };

          oauthEnable = mkOption {
            type = bool;
            description = "Configure oauth proxy.";
            default = true;
          };
        };
      };
    };

    hydra.s3Bucket = mkOption {
      type = nullOr str;
      description =
        "Specify a bucket name to use an existing bucket to upload docker images to. If set to null (default) a bucket will be created.";
      default = null;
    };
  };
}
