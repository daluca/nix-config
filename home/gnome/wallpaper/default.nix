{ config, ... }:

{
  home.file.".local/share/backgrounds/anime-nineish-dark-wallpaper.png".source = ./nix-Wallpaper.png;

  dconf.settings."org/gnome/desktop/background" = {
    color-shading-type = "solid";
    picture-options = "zoom";
    picture-uri = "file:///home/daluca/.local/share/backgrounds/anime-nineish-dark-wallpaper.png";
    primary-color = "#000000000000";
    secondary-color = "#000000000000";
  };
}
