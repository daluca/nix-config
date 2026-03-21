{ config, lib, pkgs, secrets, inputs, ... }@args:
let
  osConfig = (if args ? "osConfig" then args.osConfig else { system.stateVersion = config.home.stateVersion; });
  firefoxModule = module: import (lib.custom.relativeToHomeManagerModules "firefox/${module}.nix");
in {
  imports = with inputs; [
    zen-browser.homeModules.default
  ];

  programs.zen-browser = {
    enable = true;
    policies = firefoxModule "policies" // firefoxModule "extensions" { inherit config lib pkgs; };
    profiles.default = {
      id = 0;
      isDefault = true;
      search = firefoxModule "search" { inherit config pkgs osConfig secrets; };
      bookmarks = firefoxModule "bookmarks" { inherit secrets; };
      settings = firefoxModule "arkenfox" // {
        # Browser
        "browser.startup.page" = 1;
        "browser.startup.homepage" = "about:home";
        "browser.newtabpage.enabled" = true;
        # Zen Browser
        "zen.welcome-screen.seen" = true;
      };
    };
  };

  programs.firefox.profiles.default.settings = {
    "browser.shell.checkDefaultBrowser" = false;
  };

  xdg.mimeApps.defaultApplicationPackages = [
    config.programs.zen-browser.package
  ];

  home.persistence.home.directories = [
    ".config/zen"
  ];

  home.sessionVariables = {
    BROWSER = lib.mkForce (lib.getExe config.programs.zen-browser.package);
  };
}
