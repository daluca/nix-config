{
  config,
  lib,
  pkgs,
  ...
}:

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

  environment.variables = {
    # A fix so the mouse cursor doesn't disappear over alacritty.
    XCURSOR_THEME = "Adwaita";
  };

  sound.enable = lib.mkDefault true;

  hardware.pulseaudio.enable = lib.mkDefault true;
}
