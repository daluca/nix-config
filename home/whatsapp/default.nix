{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    wasistlos
  ];

  xdg.configFile."wasistlos/settings.conf".text = lib.generators.toINI {} {
    general = {
      notification-sounds = true;
      close-to-tray = true;
    };
    web = {
      hw-accel = 1;
      allow-permissions = true;
    };
    appearance = {
      prefer-dark-theme = true;
    };
  };

  home.persistence.home.directories = [
    ".local/share/wasistlos"
  ];
}
