{ config, lib, pkgs, ... }:

{
  imports = [
    ./rules
  ];

  services.opensnitch = {
    enable = true;
    rules = {
      systemd-timesyncd = {
        name = "systemd-timesyncd";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${config.systemd.package}/lib/systemd/systemd-timesyncd";
        };
      };
      systemd-resolved = {
        name = "systemd-resolved";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${config.systemd.package}/lib/systemd/systemd-resolved";
        };
      };
      nix = {
        name = "nix";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "list";
          operand = "list";
          list = [
            {
              type = "simple";
              operand = "process.path";
              data = "${pkgs.nix}/bin/nix";
            }
            {
              type = "regexp";
              operand = "dest.port";
              data = "^(53|443)$";
            }
          ];
        };
      };
      avahi = lib.mkIf config.services.avahi.enable {
        name = "avahi-daemon";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          operand = "process.path";
          data = "${config.services.avahi.package}/bin/avahi-daemon";
        };
      };
      nsncd = lib.mkIf config.services.nscd.enable {
        name = "nsncd";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          operand = "process.path";
          data = "${pkgs.nsncd}/bin/nsncd";
        };
      };
    };
  };
}
