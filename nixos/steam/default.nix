{ lib, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      ge-proton9-13
      ge-proton9-12
      ge-proton9-11
      ge-proton8-32
    ];
  };

  programs.gamemode.enable = true;

  hardware.xpadneo.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];
}
