{ config, lib, pkgs, secrets, osConfig, inputs, ... }:
let
  firefoxModule = module: import (lib.custom.relativeToHomeManagerModules "firefox/${module}.nix");
in {
  imports = [
    inputs.zen-browser.homeModules.default
  ];

  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = with pkgs; [
      firefoxpwa
    ];
    policies = firefoxModule "policies" // firefoxModule "extensions" { inherit lib pkgs; };
    profiles.${config.home.username} = {
      search = firefoxModule "search" { inherit config pkgs osConfig secrets; };
      bookmarks = firefoxModule "bookmarks" { inherit secrets; };
      settings = firefoxModule "arkenfox" // {
        # Browser
        "browser.startup.page" = 1;
        "browser.startup.homepage" = "about:home";
        "browser.newtabpage.enabled" = true;
     };
    };
  };

  home.persistence.home.directories = [
    ".zen"
  ];
}
