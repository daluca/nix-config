{ lib, pkgs, ... }:
let
  inherit (pkgs) ge-proton7-55 ge-proton8-32 ge-proton9-11 ge-proton9-12 ge-proton9-13 ge-proton9-14 ge-proton9-15 ge-proton9-16;
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
      ge-proton9-16
      ge-proton9-15
      ge-proton9-14
      ge-proton9-13
      ge-proton9-12
      ge-proton9-11
      ge-proton8-32
      ge-proton7-55
    ];
  };

  programs.gamemode.enable = true;

  hardware.xpadneo.enable = true;

  systemd.user.extraConfig = ''
    DefaultLimitNOFILE=${builtins.toString (8 * 1024)}
  '';
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "nofile";
      value = builtins.toString (8 * 1024);
    }
    {
      domain = "*";
      type = "-";
      item = "memlock";
      value = builtins.toString (8 * 1024);
    }
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];
}
