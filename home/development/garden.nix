{ config, pkgs, ... }:

{
  programs.garden-rs.enable = true;

  xdg.configFile."garden/garden.yaml".source = (pkgs.formats.yaml { }).generate "config" {
    garden = {
      root = "${config.home.homeDirectory}/code";
      includes = [
        "${config.home.homeDirectory}/code/garden.yaml"
      ];
    };
  };
}
