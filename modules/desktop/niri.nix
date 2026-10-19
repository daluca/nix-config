{
  self,
  inputs,
  withSystem,
  ...
}:

{
  flake.overlays.noctalia =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { inputs', ... }: {
        noctalia = inputs'.noctalia.packages.default;
      }
    );

  flake.nixosModules.niri = {
    imports = with self.nixosModules; [
      inputs.niri.nixosModules.niri
      noctalia
    ];

    home-manager.users.daluca.imports = with self.homeModules; [
      niri
    ];

    programs.niri = {
      enable = true;
    };

    services.displayManager.defaultSession = "niri";
  };

  flake.homeModules.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      spawn-sh = command: [
        "sh"
        "-c"
        command
      ];
      defaults = {
        input = {
          keyboard = {
            xkb = { };
            numlock = true;
          };
          touchpad = {
            tap = true;
            natural-scroll = true;
          };
          mouse = { };
          trackpoint = { };
        };
        layout = {
          gaps = 16;
          center-focused-column = "never";
          preset-column-widths = [
            { proportion = 1. / 3.; }
            { proportion = 1. / 2.; }
            { proportion = 2. / 3.; }
          ];
          default-column-width.proportion = 1. / 2.;
          focus-ring = {
            width = 4;
            active.color = "#7fc8ff";
            inactive.color = "#505050";
          };
          border = {
            enable = false;
            width = 4;
            active.color = "#ffc87f";
            inactive.color = "#505050";
            urgent.color = "#9b0000";
          };
          shadow = {
            softness = 30;
            spread = 5;
            offset = {
              x = 0;
              y = 5;
            };
            color = "#0007";
          };
          struts = { };
        };
        spawn-at-startup = lib.mkDefault [
          { argv = [ "waybar" ]; }
        ];
        hotkey-overlay = { };
        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
        animations = { };
        window-rules = [
          {
            matches = [ { app-id = "r#\"^org\\.wezfurlong\\.wezterm$\"#"; } ];
            default-column-width = { };
          }
          {
            matches = [
              {
                app-id = "r#\"firefox$\"#";
                title = "^Picture-in-Picture$";
              }
            ];
            open-floating = true;
          }
        ];
        binds = {
          "Mod+Shift+Slash".action.show-hotkey-overlay = { };
          "Mod+T" = {
            action.spawn = lib.mkDefault (lib.getExe config.programs.alacritty.package);
            hotkey-overlay.title = lib.mkDefault "Open a Terminal: alacritty";
          };
          "Mod+D" = lib.mkDefault {
            action.spawn = lib.getExe config.programs.fuzzel.package;
            hotkey-overlay.title = "Run an Application: fuzzel";
          };
          "Super+Alt+L" = {
            action.spawn = lib.getExe config.programs.swaylock.package;
            hotkey-overlay.title = "Lock the Screen: swaylock";
          };
          "Super+Alt+S" = {
            action.spawn = spawn-sh "pkill orca || exec orca";
            allow-when-locked = true;
            hotkey-overlay.hidden = true;
          };
          "XF86AudioRaiseVolume" = {
            action.spawn = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
            allow-when-locked = true;
          };
          "XF86AudioLowerVolume" = {
            action.spawn = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
            allow-when-locked = true;
          };
          "XF86AudioMute" = {
            action.spawn = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            allow-when-locked = true;
          };
          "XF86AudioMicMute" = {
            action.spawn = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            allow-when-locked = true;
          };
          "XF86AudioPlay" = {
            action.spawn = spawn-sh "playerctl play-pause";
            allow-when-locked = true;
          };
          "XF86AudioStop" = {
            action.spawn = spawn-sh "playerctl stop";
            allow-when-locked = true;
          };
          "XF86AudioPrev" = {
            action.spawn = spawn-sh "playerctl previous";
            allow-when-locked = true;
          };
          "XF86AudioNext" = {
            action.spawn = spawn-sh "${lib.getExe pkgs.playerctl} next";
            allow-when-locked = true;
          };
          "XF86MonBrightnessUp" = {
            action.spawn = [
              "brightnessctl"
              "--class=backlight"
              "set"
              "+10%"
            ];
            allow-when-locked = true;
          };
          "XF86MonBrightnessDown" = {
            action.spawn = [
              "brightnessctl"
              "--class=backlight"
              "set"
              "10%-"
            ];
            allow-when-locked = true;
          };
          "Mod+O" = {
            action.toggle-overview = { };
            repeat = false;
          };
          "Mod+Q" = {
            action.close-window = { };
            repeat = false;
          };
          "Mod+Left".action.focus-column-left = { };
          "Mod+Down".action.focus-window-down = { };
          "Mod+Up".action.focus-window-up = { };
          "Mod+Right".action.focus-column-right = { };
          "Mod+H".action.focus-column-left = { };
          "Mod+J".action.focus-window-down = { };
          "Mod+K".action.focus-window-up = { };
          "Mod+L" = lib.mkDefault { action.focus-column-right = { }; };
          "Mod+Ctrl+Left".action.move-column-left = { };
          "Mod+Ctrl+Down".action.move-window-down = { };
          "Mod+Ctrl+Up".action.move-window-up = { };
          "Mod+Ctrl+Right".action.move-column-right = { };
          "Mod+Ctrl+H".action.move-column-left = { };
          "Mod+Ctrl+J".action.move-window-down = { };
          "Mod+Ctrl+K".action.move-window-up = { };
          "Mod+Ctrl+L".action.move-column-right = { };
          "Mod+Home".action.focus-column-first = { };
          "Mod+End".action.focus-column-last = { };
          "Mod+Ctrl+Home".action.move-column-to-first = { };
          "Mod+Ctrl+End".action.move-column-to-last = { };
          "Mod+Shift+Left".action.focus-monitor-left = { };
          "Mod+Shift+Down".action.focus-monitor-down = { };
          "Mod+Shift+Up".action.focus-monitor-up = { };
          "Mod+Shift+Right".action.focus-monitor-right = { };
          "Mod+Shift+H".action.focus-monitor-left = { };
          "Mod+Shift+J".action.focus-monitor-down = { };
          "Mod+Shift+K".action.focus-monitor-up = { };
          "Mod+Shift+L".action.focus-monitor-right = { };
          "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = { };
          "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = { };
          "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = { };
          "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = { };
          "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = { };
          "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = { };
          "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = { };
          "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = { };
          "Mod+Page_Down".action.focus-workspace-down = { };
          "Mod+Page_Up".action.focus-workspace-up = { };
          "Mod+U".action.focus-workspace-down = { };
          "Mod+I".action.focus-workspace-up = { };
          "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = { };
          "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = { };
          "Mod+Ctrl+U".action.move-column-to-workspace-down = { };
          "Mod+Ctrl+I".action.move-column-to-workspace-up = { };
          "Mod+Shift+Page_Down".action.move-workspace-down = { };
          "Mod+Shift+Page_Up".action.move-workspace-up = { };
          "Mod+Shift+U".action.move-workspace-down = { };
          "Mod+Shift+I".action.move-workspace-up = { };
          "Mod+WheelScrollDown" = {
            action.focus-workspace-down = { };
            cooldown-ms = 150;
          };
          "Mod+WheelScrollUp" = {
            action.focus-workspace-up = { };
            cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollDown" = {
            action.move-column-to-workspace-down = { };
            cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollUp" = {
            action.move-column-to-workspace-up = { };
            cooldown-ms = 150;
          };
          "Mod+WheelScrollRight".action.focus-column-right = { };
          "Mod+WheelScrollLeft".action.focus-column-left = { };
          "Mod+Ctrl+WheelScrollRight".action.move-column-right = { };
          "Mod+Ctrl+WheelScrollLeft".action.move-column-left = { };
          "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
          "Mod+Shift+WheelScrollUp".action.focus-column-left = { };
          "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = { };
          "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = { };
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+Ctrl+1".action.move-column-to-workspace = 1;
          "Mod+Ctrl+2".action.move-column-to-workspace = 2;
          "Mod+Ctrl+3".action.move-column-to-workspace = 3;
          "Mod+Ctrl+4".action.move-column-to-workspace = 4;
          "Mod+Ctrl+5".action.move-column-to-workspace = 5;
          "Mod+Ctrl+6".action.move-column-to-workspace = 6;
          "Mod+Ctrl+7".action.move-column-to-workspace = 7;
          "Mod+Ctrl+8".action.move-column-to-workspace = 8;
          "Mod+Ctrl+9".action.move-column-to-workspace = 9;
          "Mod+BracketLeft".action.consume-or-expel-window-left = { };
          "Mod+BracketRight".action.consume-or-expel-window-right = { };
          "Mod+Comma".action.consume-window-into-column = { };
          "Mod+Period".action.expel-window-from-column = { };
          "Mod+R".action.switch-preset-column-width = { };
          "Mod+Shift+R".action.switch-preset-column-width-back = { };
          "Mod+Ctrl+Shift+R".action.switch-preset-window-height = { };
          "Mod+Ctrl+R".action.reset-window-height = { };
          "Mod+F".action.maximize-column = { };
          "Mod+Shift+F".action.fullscreen-window = { };
          "Mod+M".action.maximize-window-to-edges = { };
          "Mod+Ctrl+F".action.expand-column-to-available-width = { };
          "Mod+C".action.center-column = { };
          "Mod+Ctrl+C".action.center-visible-columns = { };
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";
          "Mod+V".action.toggle-window-floating = { };
          "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };
          "Mod+W".action.toggle-column-tabbed-display = { };
          "Print" = lib.mkDefault { action.screenshot = { }; };
          "Ctrl+Print".action.screenshot-screen = { };
          "Alt+Print".action.screenshot-window = { };
          "Mod+Escape" = {
            action.toggle-keyboard-shortcuts-inhibit = { };
            allow-inhibiting = false;
          };
          "Mod+Shift+E".action.quit = { };
          "Ctrl+Alt+Delete".action.quit = { };
          "Mod+Shift+P".action.power-off-monitors = { };
        };
      };
    in
    {
      programs.niri.settings = lib.recursiveUpdate defaults {
        input.keyboard = {
          xkb = {
            layout = "us,us";
            variant = "dvorak,";
          };
          numlock = true;
        };
        cursor =
          let
            milliseconds = 1000;
          in
          {
            theme = "Adwaita";
            size = 24;
            hide-after-inactive-ms = 30 * milliseconds;
            hide-when-typing = true;
          };
        binds = {
          "Mod+T" = {
            action.spawn = lib.getExe config.programs.ghostty.package;
            hotkey-overlay.title = "Open a Terminal: ghostty";
          };
          "Mod+Backspace" = {
            action.close-window = { };
            repeat = false;
          };
        };
        window-rules =
          let
            zen-browser = {
              app-id = "^zen-beta$";
            };
            ghostty = {
              app-id = "^com.mitchellh.ghostty$";
            };
            firefox = {
              app-id = "firefox$";
            };
            vscodium = {
              app-id = "^codium$";
            };
            thunderbird = {
              app-id = "^thunderbird$";
            };
          in
          [
            {
              matches = map (browser: browser // { title = "^Picture-in-Picture$"; }) [
                zen-browser
                firefox
              ];
              open-floating = true;
              # TODO: Enable on next stable Niri release
              # on-xdg-activate = "focus";
              default-column-width.fixed = 854;
              default-window-height.fixed = 480;
              default-floating-position = {
                x = 24;
                y = 24;
                relative-to = "bottom-right";
              };
            }
            {
              matches = [
                zen-browser
                ghostty
                vscodium
                thunderbird
              ];
              excludes = [
                { title = "^Picture-in-Picture$"; }
                { title = "^Extension: (Bitwarden Password Manager)"; }
              ];
              default-column-width.proportion = 2. / 3.;
            }
            {
              matches = map (browser: browser // { title = "^Extension: (Bitwarden Password Manager)"; }) [
                zen-browser
                firefox
              ];
              open-floating = true;
            }
          ];
        layout = {
          always-center-single-column = true;
        };
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      };
    };
}
