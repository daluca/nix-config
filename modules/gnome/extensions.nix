{ self, ... }:

{
  flake.homeManagerModules.gnome-extensions = { lib, ... }: {
    imports = with self.homeManagerModules; [
      gnome-extensions-appindicator
      gnome-extensions-caffeine
      gnome-extensions-inPicture
      gnome-extensions-noOverview
      gnome-extensions-paperwm
    ];

    dconf.settings."org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = lib.mkDefault [ ];
    };
  };

  flake.homeManagerModules.gnome-extensions-appindicator = { pkgs, ... }: with pkgs.gnomeExtensions; {
    dconf.settings."org/gnome/shell" = {
      enabled-extensions = [ appindicator.extensionUuid ];
    };
  };

  flake.homeManagerModules.gnome-extensions-autoCpufreqSwitcher = { pkgs, ... }: with pkgs.gnomeExtensions; {
    home.packages = [
      auto-cpufreq-switcher
    ];

    dconf.settings."org/gnome/shell" = {
      enabled-extensions = [ auto-cpufreq-switcher.extensionUuid ];
    };
  };

  flake.homeManagerModules.gnome-extensions-caffeine = { pkgs, ... }: with pkgs.gnomeExtensions; {
    home.packages = [
      caffeine
    ];

    dconf.settings."org/gnome/shell" = {
      enabled-extensions = [ caffeine.extensionUuid ];
    };
  };

  flake.homeManagerModules.gnome-extensions-inPicture = { pkgs, ... }: with pkgs.gnomeExtensions; {
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

  flake.homeManagerModules.gnome-extensions-noOverview = { pkgs, ... }: with pkgs.gnomeExtensions; {
    home.packages = [
      no-overview
    ];

    dconf.settings."org/gnome/shell" = {
      enabled-extensions = [ no-overview.extensionUuid ];
    };
  };

  flake.homeManagerModules.gnome-extensions-paperwm = { pkgs, lib, ... }: with pkgs.gnomeExtensions; {
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

  flake.homeManagerModules.gnome-extensions-tailscaleQs = { pkgs, lib, osConfig, ... }: with pkgs.gnomeExtensions; lib.mkIf osConfig.services.tailscale.enable {
    home.packages = [
      tailscale-qs
    ];

    dconf.settings."org/gnome/shell" = {
      enabled-extensions = [ tailscale-qs.extensionUuid ];
    };
  };
}
