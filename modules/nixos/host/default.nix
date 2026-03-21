{ lib, ... }:

with lib; {
  options.host = {
    battery = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether the host has a battery or not";
    };

    network = lib.mkOption {
      type = types.submodule {
        options = {
          interface = lib.mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "What is the primary network interface";
          };
        };
      };
      default = { };
    };
  };
}
