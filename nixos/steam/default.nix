{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraProfile = ''
        export SDL_JOYSTICK_HIDAPI_XBOX=0
      '';

      extraLibraries =
        _pkg: with pkgs; [
          # Work-around for wayland
          # https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1229444338
          libxcursor
          libxi
          libxinerama
          libxscrnsaver
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
      GE-Proton11-1
      GE-Proton10-34
      GE-Proton10-33
      GE-Proton10-32
      GE-Proton10-31
      GE-Proton10-30
      GE-Proton9
      GE-Proton8
      GE-Proton7
    ];
  };

  programs.gamemode.enable = true;

  hardware.xpadneo.enable = true;
}
