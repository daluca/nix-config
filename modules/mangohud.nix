{
  flake.homeManagerModules.mangohud = { pkgs, ... }: {
    programs.mangohud = {
      enable = true;
      settings = {
        no_display = true;
      };
      settingsPerApplication = {
        wine-Cyberpunk2077 = {
          preset = 1;
          position = "top-right";
          no_display = true;
        };
      };
    };

    home.packages = with pkgs; [
      mangohud
    ];

    # NOTE: catppuccin completely overwrite mangohud config
    # No current work arounds
    # https://github.com/catppuccin/nix/issues/999
    catppuccin.mangohud.enable = false;
  };
}
