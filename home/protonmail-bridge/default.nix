{ pkgs, ... }:

{
  services.protonmail-bridge = {
    enable = true;
    extraPackages = with pkgs; [
      gnome-keyring
    ];
  };

  sops.secrets."protonmail-bridge/password" = { };

  home.persistence.home.directories = [
    ".config/protonmail/bridge-v3"
    ".local/share/protonmail/bridge-v3"
  ];
}
