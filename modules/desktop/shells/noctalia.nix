{ self, inputs, ... }:

{
  flake.nixosModules.noctalia = {
    imports = with inputs; [
      noctalia.nixosModules.default
    ];

    home-manager.users.daluca.imports = with self.homeModules; [
      noctalia
    ];

    nix.settings = {
      substituters = [ "https://noctalia.cachix.org" ];
      trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };
  };

  flake.homeModules.noctalia = { lib, pkgs, ... }: {
    imports = with inputs; [
      noctalia.homeModules.default
    ];

    programs.noctalia = {
      enable = true;
      settings = {
        idle = {
          behavior_order = [
            "lock"
            "screen_off"
            "suspend"
          ];
          behavior.lock = {
            enabled = true;
            action = "lock";
            timeout = 600;
          };
          behavior.screen-off = {
            enabled = true;
            action = "screen_off";
            timeout = 660;
          };
          behavior.suspend = {
            enabled = true;
            action = "suspend";
            timeout = 900;
          };
        };
        hooks = {
          # NOTE: Revert once keyring unlock no longer prompts on startup
          # started = "noctalia msg panel-toggle launcher";
        };
        shell = {
          niri_overview_type_to_launch_enabled = true;
        };
        theme = {
          source = "community";
          builtin = "Catppuccin";
          community_palette = "Catppuccin Mocha Mauve-Lavender";
        };
        wallpaper = {
          automation.enabled = true;
          default.path = pkgs.fetchurl {
            url = "https://i.redd.it/ch72w5o76e591.png";
            hash = "sha256-v5G1AJkkhdBrLV4Tw30f3sdw0QqyG5HyypPOj24A/+w=";
            name = "boston-usa.png";
          };
        };
        nightlight.enabled = true;
        location.auto_locate = true;
        shell.launcher.track_usage = false;
        shell.keyboard_layout.custom_labels = {
          "English (Dvorak)" = "DV";
          "English (US)" = "EN";
        };
        weather = {
          unit = "metric";
          effects = true;
        };
        lockscreen = {
          fingerprint = false;
          allow_empty_password = true;
        };
        bar.default.end = [
          "media"
          "tray"
          "notifications"
          "clipboard"
          "network"
          "bluetooth"
          "volume"
          "keyboard_layout"
          "brightness"
          "battery"
          "control-center"
          "session"
        ];
        widget.keyboard_layout = {
          hide_when_single_layout = true;
          show_glyph = true;
          show_label = true;
          display = "short";
        };
        widget.media = {
          hide_when_no_media = true;
        };
      };
    };

    programs.niri.settings = {
      spawn-at-startup = [
        { argv = [ "noctalia" ]; }
      ];
      hotkey-overlay.skip-at-startup = true;
      window-rules =
        let
          noctalia = {
            app-id = "dev.noctalia.Noctalia";
          };
        in
        [
          {
            geometry-corner-radius =
              let
                radius = 20.;
              in
              {
                top-left = radius;
                top-right = radius;
                bottom-left = radius;
                bottom-right = radius;
              };
            clip-to-geometry = true;
          }
          {
            matches = [ noctalia ];
            open-floating = true;
            default-column-width.fixed = 1080;
            default-window-height.fixed = 920;
          }
        ];
      binds =
        let
          spawn-sh = command: [
            "sh"
            "-c"
            command
          ];
        in
        {
          "XF86AudioPlay" = lib.mkForce {
            action.spawn = spawn-sh "noctalia msg media toggle";
            allow-when-locked = true;
          };
          "XF86AudioStop" = lib.mkForce {
            action.spawn = spawn-sh "noctalia msg media stop";
            allow-when-locked = true;
          };
          "XF86AudioPrev" = lib.mkForce {
            action.spawn = spawn-sh "noctalia msg media previous";
            allow-when-locked = true;
          };
          "XF86AudioNext" = lib.mkForce {
            action.spawn = spawn-sh "noctalia msg media next";
            allow-when-locked = true;
          };
          "Print".action.spawn = spawn-sh "noctalia msg annotate";
          "Alt+Space".action.spawn = spawn-sh "noctalia msg panel-toggle launcher";
          "Mod+D".action.spawn = spawn-sh "noctalia msg panel-toggle launcher";
          "Alt+Tab".action.spawn = spawn-sh "noctalia msg window-switcher hold";
          "Mod+L".action.spawn = spawn-sh "noctalia msg session lock";
          "Super+Space".action.spawn = spawn-sh "noctalia msg keyboard-layout-cycle";
        };
      debug.honor-xdg-activation-with-invalid-serial = { };
    };

    home.persistence.home.directories = [
      ".local/state/noctalia"
    ];
  };
}
