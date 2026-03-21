{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraLibraries = _pkg: with pkgs; [
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
      GE-Proton10-34
      GE-Proton10-33
      GE-Proton10-32
      GE-Proton10-31
      GE-Proton10-30
      GE-Proton9-27
      GE-Proton8-32
      GE-Proton7-55
    ];
  };

  programs.gamemode.enable = true;

  hardware.xpadneo.enable = true;
}
