{ config, pkgs, ... }:

{
  imports =
    [
      ./gnome.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Pacific/Auckland";

  users.users.daluca = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    git
  ];
}
