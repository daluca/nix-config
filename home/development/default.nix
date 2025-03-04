{ config, pkgs, ... }:
let
  inherit (pkgs.formats) yaml;
  inherit (config.home) homeDirectory;
in {
  imports = [
    ../garden
    ../direnv
    ../just
    ../jujutsu
  ];

  home.persistence.home.directories = [
    "code"
  ];

  xdg.configFile."garden/garden.yaml".source = (yaml { }).generate "config" {
    garden = {
      root = "${homeDirectory}/code";
      includes = [
        "${homeDirectory}/code/garden.yaml"
      ];
    };
  };
}
