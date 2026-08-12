let
  secrets = fromTOML (builtins.readFile ../secrets/secrets.toml);
in {
  flake.homeManagerModules.atuin = { config, pkgs, ... }: {
    programs.atuin = {
      enable = true;
      package = pkgs.unstable.atuin;
      enableBashIntegration = false;
      daemon.enable = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://atuin.${secrets.domain.general}/";
        dialect = "uk";
        update_check = false;
        keymap_mode = "vim-insert";
        search_mode = "daemon-fuzzy";
        filter_mode = "host";
        key_path = config.sops.secrets."atuin/key".path;
        logs.dir = "~/.local/share/atuin/logs/";
        tmux.enabled = true;
        ui.syntax_highlight = true;
      };
    };

    sops.secrets."atuin/key" = { };

    catppuccin.atuin.enable = true;

    programs.ghostty.settings = {
      keybind = [
        "alt+one=unbind"
        "alt+two=unbind"
        "alt+three=unbind"
        "alt+four=unbind"
        "alt+five=unbind"
        "alt+six=unbind"
        "alt+seven=unbind"
        "alt+eight=unbind"
        "alt+nine=unbind"
      ];
    };

    home.persistence.home.directories = [
      ".local/share/atuin"
    ];
  };
}
