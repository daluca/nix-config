{ config, pkgs, ... }:

{
  imports = [
    ./gnome.nix
    ./gnupg
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  time.timeZone = "Pacific/Auckland";

  users.users.daluca = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [ git ];
}
