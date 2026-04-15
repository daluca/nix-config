{ pkgs, ... }:
let
  wallpaper = {
    color-shading-type = "solid";
    picture-options = "zoom";
    picture-uri = "file://${pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-nineish.png";
      hash = "sha256-EMSD1XQLaqHs0NbLY0lS1oZ4rKznO+h9XOGDS121m9c=";
    }}";
    picture-uri-dark = "file://${pkgs.fetchurl {
      url = "https://i.imgur.com/xsSEqjJ.jpeg";
      hash = "sha256-7AcgbUEOfcdFHl2aBGw8WdPnTpwG2GaKQRTFU1bNsS0=";
      name = "nighty-mode-wallpaper.jpeg";
    }}";
    primary-color = "#000000000000";
    secondary-color = "#000000000000";
  };
in {
  dconf.settings."org/gnome/desktop/background" = wallpaper;
  dconf.settings."org/gnome/desktop/screensaver" = wallpaper;
}
