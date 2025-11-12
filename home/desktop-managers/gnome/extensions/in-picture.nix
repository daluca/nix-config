{ lib, pkgs, ... }:

with pkgs.gnomeExtensions; {
  home.packages = [ in-picture ];

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/shell".enabled-extensions = [
      in-picture.extensionUuid
    ];
    "org/gnome/shell/extensions/in-picture" = {
      stick = true;
      top = true;
      corner = 3; # Bottom right
      margin-x = 0;
      margin-y = 0;
      use-relative = true;
      diagonal-relative = 30;
      identifiers = [
        [ "Picture-in-Picture" "firefox.desktop" ]
        [ "Picture-in-Picture" "zen-beta.desktop" ]
      ];
    };
  };
}
