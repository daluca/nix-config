{ config, lib, pkgs, osConfig, ... }:
let
  inherit (pkgs.formats) yaml;
  inherit (pkgs.unstable) zed-editor;
  inherit (lib) mkIf;
  inherit (config.home) homeDirectory;
  inherit (osConfig.environment) persistence;
in {
  imports = [
    ../garden
    ../direnv
    ../just
    ../jujutsu
  ];

  home.persistence.home.directories = mkIf persistence.system.enable [
    "code"
  ];

  xdg.configFile."garden/garden.yaml".source = (yaml {}).generate "config" {
    garden = {
      root = "${homeDirectory}/code";
      includes = [
        "${homeDirectory}/code/garden.yaml"
      ];
    };
  };
}
