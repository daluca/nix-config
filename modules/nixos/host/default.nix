{ lib, ... }:

with lib; {
  options.host = {
    battery = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether the host has a battery or not";
    };

    work = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether the host is for work";
    };

    network = lib.mkOption {
      type = types.submodule {
        options = {
          interface = lib.mkOption {
            type = types.str;
            description = "What is the primary network interface";
          };
        };
      };
    };
  };
}
