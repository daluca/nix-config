{ pkgs, ... }:
let
  inherit (pkgs) fetchurl;
  wallpaper = {
    color-shading-type = "solid";
    picture-options = "zoom";
    picture-uri = "file://${fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-nineish.png";
      hash = "sha256-EMSD1XQLaqHs0NbLY0lS1oZ4rKznO+h9XOGDS121m9c=";
    }}";
    picture-uri-dark = "file://${fetchurl {
      url = "https://preview.redd.it/anime-nix-wallpaper-i-created-v0-0f6oxa9y9jlb1.png?auto=webp&s=68f30e78fad03d4add57ef3139667b402d84fdbb";
      hash = "sha256-fEzF9L2PYf6WCKC6Q7OVx6ZIeeJnuST4gZ45QEMPpmY=";
      name = "nix-wallpaper-nineish-anime.png";
    }}";
    primary-color = "#000000000000";
    secondary-color = "#000000000000";
  };
in {
  dconf.settings."org/gnome/desktop/background" = wallpaper;
  dconf.settings."org/gnome/desktop/screensaver" = wallpaper;
}
