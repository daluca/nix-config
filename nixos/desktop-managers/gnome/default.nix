{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
    yelp
    gnome-text-editor
  ];

  environment.systemPackages = with pkgs; [
    papers
    gnome-sound-recorder
    gnomeExtensions.appindicator
  ];

  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  # TODO: check if GNOME browser connection is working
  # TODO: update to home-manager config of firefox
  services.gnome.gnome-browser-connector.enable = true; # lib.mkIf ( config.programs.firefox.enable || config.home-manager.users.daluca.programs.firefox.enable );

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${../../../home/desktop-managers/gnome/monitors.xml}"
  ];
}
