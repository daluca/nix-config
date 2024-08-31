{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]);

  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
  ];

  services.udev.packages = with pkgs.gnome; [
    gnome-settings-daemon
  ];

  # TODO: check if GNOME browser connection is working
  # TODO: update to home-manager config of firefox
  services.gnome.gnome-browser-connector.enable = lib.mkIf config.programs.firefox.enable true;
}
