{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./git
  ];

  home = {
    username = "daluca";
    homeDirectory = "/home/daluca";

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
