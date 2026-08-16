{ self, ... }:

{
  flake.nixosModules.steam = { pkgs, ... }: {
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

    home-manager.users.daluca.imports = with self.homeManagerModules; [
      steam
    ];
  };

  flake.homeManagerModules.steam = { pkgs, ... }: {
    xdg.dataFile = with pkgs; {
      "Steam/compatibilitytools.d/GE-Proton11".source = lib.getOutput "steamcompattool" GE-Proton11;
      "Steam/compatibilitytools.d/GE-Proton11-5".source = lib.getOutput "steamcompattool" GE-Proton11-5;
      "Steam/compatibilitytools.d/GE-Proton11-4".source = lib.getOutput "steamcompattool" GE-Proton11-4;
      "Steam/compatibilitytools.d/GE-Proton11-3".source = lib.getOutput "steamcompattool" GE-Proton11-3;
      "Steam/compatibilitytools.d/GE-Proton11-2".source = lib.getOutput "steamcompattool" GE-Proton11-2;
      "Steam/compatibilitytools.d/GE-Proton11-1".source = lib.getOutput "steamcompattool" GE-Proton11-1;
      "Steam/compatibilitytools.d/GE-Proton10".source = lib.getOutput "steamcompattool" GE-Proton10;
      "Steam/compatibilitytools.d/GE-Proton9".source = lib.getOutput "steamcompattool" GE-Proton9;
      "Steam/compatibilitytools.d/GE-Proton8".source = lib.getOutput "steamcompattool" GE-Proton8;
      "Steam/compatibilitytools.d/GE-Proton7".source = lib.getOutput "steamcompattool" GE-Proton7;
    };

    home.persistence.home.directories = [
      ".local/share/Steam"
    ];
  };
}
