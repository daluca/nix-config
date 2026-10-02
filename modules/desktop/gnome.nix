{ self, ... }:

{
  flake.nixosModules.gnome = { lib, pkgs, ... }: {
    home-manager.users.daluca.imports = with self.homeModules; [
      gnome
      profile
    ];

    services.desktopManager.gnome.enable = true;

    services.displayManager.gdm.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      epiphany
      geary
      yelp
      gnome-text-editor
    ];

    environment.systemPackages = with pkgs; [
      gnome-sound-recorder
      gnomeExtensions.appindicator
    ];

    services.udev.packages = with pkgs; [
      gnome-settings-daemon
    ];

    services.gnome.gnome-browser-connector.enable = true;

    services.xserver.xkb.options = lib.mkForce "";
  };

  flake.homeModules.gnome =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.hm.gvariant)
        mkVariant
        mkTuple
        mkUint32
        mkDouble
        ;
      wellington = mkVariant (mkTuple [
        (mkUint32 2)
        (mkVariant (mkTuple [
          "Wellington"
          "NZWN"
          true
          [
            (mkTuple [
              (mkDouble "-0.72140275167322543")
              (mkDouble "3.0508355324860883")
            ])
          ]
          [
            (mkTuple [
              (mkDouble "-0.720820981073658")
              (mkDouble "3.050544638459658")
            ])
          ]
        ]))
      ]);
      auckland = mkVariant (mkTuple [
        (mkUint32 2)
        (mkVariant (mkTuple [
          "Auckland"
          "NZAA"
          true
          [
            (mkTuple [
              (mkDouble "-0.64606271726433173")
              (mkDouble "3.0508355324860883")
            ])
          ]
          [
            (mkTuple [
              (mkDouble "-0.64344472338634029")
              (mkDouble "3.0502537618865206")
            ])
          ]
        ]))
      ]);
      london = mkVariant (mkTuple [
        (mkUint32 2)
        (mkVariant (mkTuple [
          "London"
          "EGWU"
          true
          [
            (mkTuple [
              (mkDouble "0.89971722940307675")
              (mkDouble "-0.007272211034407213")
            ])
          ]
          [
            (mkTuple [
              (mkDouble "0.89884456477707964")
              (mkDouble "-0.0020362232784242244")
            ])
          ]
        ]))
      ]);
      amsterdam = mkVariant (mkTuple [
        (mkUint32 2)
        (mkVariant (mkTuple [
          "Amsterdam"
          "EHAM"
          true
          [
            (mkTuple [
              (mkDouble "0.91280719879303418")
              (mkDouble "0.083194033496160544")
            ])
          ]
          [
            (mkTuple [
              (mkDouble "0.91402892926943036")
              (mkDouble "0.085346600422522706")
            ])
          ]
        ]))
      ]);
      the-hague = mkVariant (mkTuple [
        (mkUint32 2)
        (mkVariant (mkTuple [
          "The Hague"
          "EHRD"
          true
          [
            (mkTuple [
              (mkDouble "0.9066985464110543")
              (mkDouble "0.077667151713747662")
            ])
          ]
          [
            (mkTuple [
              (mkDouble "0.90896747443864678")
              (mkDouble "0.075223690760955586")
            ])
          ]
        ]))
      ]);
      delft = mkVariant (mkTuple [
        (mkUint32 2)
        (mkVariant (mkTuple [
          "Delft"
          "EHRD"
          true
          [
            (mkTuple [
              (mkDouble "0.9066985464110543")
              (mkDouble "0.077667151713747662")
            ])
          ]
          [
            (mkTuple [
              (mkDouble "0.90774574396225083")
              (mkDouble "0.076096355386952766")
            ])
          ]
        ]))
      ]);
      wallpaper = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file://${
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-nineish.png";
            hash = "sha256-EMSD1XQLaqHs0NbLY0lS1oZ4rKznO+h9XOGDS121m9c=";
          }
        }";
        picture-uri-dark = "file://${
          pkgs.fetchurl {
            url = "https://i.redd.it/zn8oyt5xqjxc1.png";
            hash = "sha256-NdfGfwf97e0DQhwrV/zkHw0jTV+NPOgYWbqIziaWgwc=";
            name = "dark-mode-wallpaper.png";
          }
        }";
        primary-color = "#000000000000";
        secondary-color = "#000000000000";
      };
    in
    {
      imports = with self.homeModules; [
        gnome-extensions
      ];

      dconf.settings = with lib.hm.gvariant; {
        "org/gnome/mutter" = {
          dynamic-workspaces = true;
          experimental-features = [ "scale-monitor-framebuffer" ];
          edge-tiling = true;
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
        };
        "org/gnome/desktop/input-sources" = {
          sources = [
            (mkTuple [
              "xkb"
              "us+dvorak"
            ])
            (mkTuple [
              "xkb"
              "us"
            ])
          ];
        };
        "org/gnome/desktop/peripherals/keyboard" = {
          numlock-state = true;
        };
        "org/gnome/desktop/peripherals/mouse" = {
          mkDouble = "-0.29059829059829057";
        };
        "org/gnome/desktop/input-sources" = {
          xkb-options = [
            "lv3:switch"
            "compose:ralt"
          ];
        };
        "org/gnome/desktop/background" = wallpaper;
        "org/gnome/desktop/screensaver" = wallpaper;
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
        };
        "org/gnome/settings-daemon/plugins/housekeeping" = {
          donation-reminder-enabled = false;
        };
        "org/gnome/shell" = {
          favorite-apps =
            (if config.programs.zen-browser.enable then [ "zen-beta.desktop" ] else [ "firefox.desktop" ])
            ++ [
              "com.mitchellh.ghostty.desktop"
            ];
        };
        "org/gnome/GWeather4" = {
          temperature-unit = "centigrade";
        };
        "org/gnome/Weather" = {
          locations = [
            delft
            the-hague
            wellington
            auckland
            london
            amsterdam
          ];
        };
        "org/gnome/shell/weather" = {
          locations = [
            delft
            the-hague
            wellington
            auckland
            london
            amsterdam
          ];
        };
        "org/gnome/clocks" = {
          world-clocks = [
            [
              (mkDictionaryEntry [
                "location"
                delft
              ])
            ]
            [
              (mkDictionaryEntry [
                "location"
                auckland
              ])
            ]
            [
              (mkDictionaryEntry [
                "location"
                london
              ])
            ]
          ];
        };
        "org/gnome/shell/world-clocks" = {
          locations = [
            delft
            auckland
            london
          ];
        };
      };

      gtk.enable = true;

      gtk.gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk.gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      xdg.terminal-exec.settings.GNOME = [
        "com.mitchellh.ghostty.desktop"
        "Alacritty.desktop"
        "org.gnome.Terminal.desktop"
      ];

      home.packages = with pkgs; [
        wl-clipboard
      ];
    };

  flake.homeModules.gnome-extensions = { lib, ... }: {
    imports = with self.homeModules; [
      gnome-extensions-appindicator
      gnome-extensions-caffeine
      gnome-extensions-in-picture
      gnome-extensions-no-overview
      gnome-extensions-paperwm
    ];

    dconf.settings."org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = lib.mkDefault [ ];
    };
  };

  flake.homeModules.gnome-extensions-appindicator = { pkgs, ... }: with pkgs.gnomeExtensions;
    {
      dconf.settings."org/gnome/shell" = {
        enabled-extensions = [ appindicator.extensionUuid ];
      };
    };

  flake.homeModules.gnome-extensions-auto-cpufreq-switcher =
    {
      pkgs,
      ...
    }:
    with pkgs.gnomeExtensions;
    {
      home.packages = [
        auto-cpufreq-switcher
      ];

      dconf.settings."org/gnome/shell" = {
        enabled-extensions = [ auto-cpufreq-switcher.extensionUuid ];
      };
    };

  flake.homeModules.gnome-extensions-caffeine = { pkgs, ... }: with pkgs.gnomeExtensions;
    {
      home.packages = [
        caffeine
      ];

      dconf.settings."org/gnome/shell" = {
        enabled-extensions = [ caffeine.extensionUuid ];
      };
    };

  flake.homeModules.gnome-extensions-in-picture = { pkgs, ... }: with pkgs.gnomeExtensions;
    {
      home.packages = [
        in-picture
      ];

      dconf.settings."org/gnome/shell" = {
        enabled-extensions = [ in-picture.extensionUuid ];
      };

      dconf.settings."org/gnome/shell/extensions/in-picture" = {
        stick = true;
        top = true;
        corner = 3; # Bottom right
        margin-x = 0;
        margin-y = 0;
        use-relative = true;
        diagonal-relative = 30;
        identifiers = [
          [
            "Picture-in-Picture"
            "firefox.desktop"
          ]
          [
            "Picture-in-Picture"
            "zen-beta.desktop"
          ]
        ];
      };
    };

  flake.homeModules.gnome-extensions-no-overview = { pkgs, ... }: with pkgs.gnomeExtensions;
    {
      home.packages = [
        no-overview
      ];

      dconf.settings."org/gnome/shell" = {
        enabled-extensions = [ no-overview.extensionUuid ];
      };
    };

  flake.homeModules.gnome-extensions-paperwm = { pkgs, lib, ... }: with pkgs.gnomeExtensions;
    {
      home.packages = [
        paperwm
      ];

      dconf.settings."org/gnome/shell" = {
        enabled-extensions = [ paperwm.extensionUuid ];
      };

      dconf.settings."org/gnome/shell/extensions/paperwm" = with lib.hm.gvariant; {
        show-window-position-bar = false;
        show-workspace-indicator = false;
        selection-border-radius-bottom = 12;
        window-gap = 10;
        horizontal-margin = 5;
        vertical-margin = 5;
        vertical-margin-bottom = 5;
        minimap-scale = mkDouble "0.0";
      };

      home.persistence.home.directories = [
        ".config/paperwm"
      ];
    };
}
