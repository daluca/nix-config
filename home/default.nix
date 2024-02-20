{ config, pkgs, ... }:

{
  imports =
    [
      ./packages.nix
    ];

  home = {
    username = "daluca";
    homeDirectory = "/home/daluca";

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
