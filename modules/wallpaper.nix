{
  flake.homeManagerModules.ultrawide-wallpaper =
    { lib, pkgs, ... }:
    let
      wallpaper = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file://${
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-nineish.png";
            hash = "sha256-EMSD1XQLaqHs0NbLY0lS1oZ4rKznO+h9XOGDS121m9c=";
          }
        }";
        picture-uri-dark = "file://${
          pkgs.fetchurl {
            url = "https://i.redd.it/zn8oyt5xqjxc1.png";
            hash = "sha256-NdfGfwf97e0DQhwrV/zkHw0jTV+NPOgYWbqIziaWgwc=";
            name = "dark-mode-wallpaper.png";
          }
        }";
        primary-color = "#000000000000";
        secondary-color = "#000000000000";
      };
    in
    {
      # NOTE: Remove mkForce once gnome dendiritic module has been created
      dconf.settings."org/gnome/desktop/background" = lib.mkForce wallpaper;
      dconf.settings."org/gnome/desktop/screensaver" = lib.mkForce wallpaper;
    };
}
