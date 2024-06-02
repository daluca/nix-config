{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome = {
      enable = true;
    };
  };

  sound.enable = true;

  hardware.pulseaudio.enable = true;
}
