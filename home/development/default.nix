{ config, lib, pkgs, osConfig, ... }:

{
  imports = [
    ../garden
    ../direnv
    ../just
  ];

  home.persistence.home.directories = lib.mkIf osConfig.environment.persistence.system.enable [
    "code"
  ];

  xdg.configFile."garden/garden.yaml".source = (pkgs.formats.yaml {}).generate "config" {
    garden = {
      root = "${config.home.homeDirectory}/code";
      includes = [
        "${config.home.homeDirectory}/code/garden.yaml"
      ];
    };
  };
}
