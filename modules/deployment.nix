{
  flake.nixosModules.deployment-options =
    { lib, ... }:
    with lib;
    {
      options = {
        deploy = lib.mkOption {
          type = types.submodule {
            options = {
              ipv4-address = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "IPv4 address of the target host.";
              };

              tags = lib.mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Extra tags used for colmena deployments.";
              };
            };
          };
          default = { };
          description = "Configuration for host deployment.";
        };
      };
    };
}
