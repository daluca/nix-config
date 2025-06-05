{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraLibraries = pkg: with pkgs; [
        # Work-around for wayland
        # https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1229444338
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      GE-Proton10-4
      GE-Proton10-3
      GE-Proton10-2
      GE-Proton10-1
      GE-Proton9-27
      GE-Proton8-32
      GE-Proton7-55
    ];
  };

  programs.gamemode.enable = true;

  hardware.xpadneo.enable = true;
}
