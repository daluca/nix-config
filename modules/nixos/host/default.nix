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
  };
}
