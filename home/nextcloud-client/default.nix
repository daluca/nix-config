{ lib, pkgs, osConfig, ... }:

{
  services.nextcloud-client = {
    enable = true;
    package = pkgs.unstable.nextcloud-client;
    startInBackground = true;
  };

  # TODO: Remove when underlying issue has been fixed
  # https://github.com/nix-community/home-manager/issues/3628#issuecomment-1407798125
  # https://github.com/NixOS/nixpkgs/blob/33867e8d862dbbe1ea2db5ca04dbe630c957db86/nixos/modules/services/x11/display-managers/default.nix#L91-L104
  #
  # This is a workaround for systemd starting the service too early
  # https://github.com/NixOS/nixpkgs/issues/206630#issuecomment-1436008585
  systemd.user.services.nextcloud-client = lib.mkIf osConfig.services.xserver.desktopManager.gnome.enable {
    Unit = {
      After = lib.mkForce "graphical-session.target";
    };
  };

  home.persistence.home.directories = lib.mkIf osConfig.environment.persistence.system.enable [
    ".config/Nextcloud"
    "Nextcloud"
  ];
}
