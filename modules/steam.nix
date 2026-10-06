{ self, inputs, ... }:

{
  flake.nixosModules.steam = { pkgs, ... }: {
    imports = with inputs; [
      proton-ge.nixosModules.default
    ];

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
        GE-Proton11
        GE-Proton11-9
        GE-Proton11-8
        GE-Proton11-7
        GE-Proton11-6
        GE-Proton11-5
        GE-Proton11-4
        GE-Proton11-3
        GE-Proton11-2
        GE-Proton11-1
        GE-Proton10
        GE-Proton9
        GE-Proton8
        GE-Proton7
      ];
    };

    programs.gamemode.enable = true;

    hardware.xpadneo.enable = true;

    home-manager.users.daluca.imports = with self.homeModules; [
      steam
    ];
  };

  flake.homeModules.steam = {
    programs.steam.exposeCompatibility = true;

    home.persistence.home.directories = [
      ".local/share/Steam"
    ];
  };
}
