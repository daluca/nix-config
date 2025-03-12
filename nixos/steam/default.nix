{ pkgs, ... }:
let
  inherit (pkgs) GE-Proton9-26 GE-Proton9-25 GE-Proton9-24 GE-Proton9-23 GE-Proton9-22 GE-Proton9-21 GE-Proton8-32 GE-Proton7-55;
  inherit (pkgs.xorg) libXcursor libXi libXinerama libXScrnSaver;
  inherit (pkgs) libpng libpulseaudio libvorbis libkrb5 keyutils;
  inherit (pkgs.stdenv.cc) cc;
  wayland-support = [
    # Work-around for wayland
    # https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1229444338
    libXcursor
    libXi
    libXinerama
    libXScrnSaver
    libpng
    libpulseaudio
    libvorbis
    cc.lib
    libkrb5
    keyutils
  ];
in {
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraLibraries = pkg: wayland-support;
    };
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = [
      GE-Proton9-26
      GE-Proton9-25
      GE-Proton9-24
      GE-Proton9-23
      GE-Proton9-22
      GE-Proton9-21
      GE-Proton8-32
      GE-Proton7-55
    ];
  };

  programs.gamemode.enable = true;

  hardware.xpadneo.enable = true;
}
