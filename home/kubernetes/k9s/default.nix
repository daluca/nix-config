{ pkgs, ... }:
let
  inherit (pkgs.unstable) k9s;
in {
  programs.k9s = {
    enable = true;
    package = k9s;
    settings.k9s = {
      ui = {
        enableMouse = false;
        logoless = true;
      };
      skipLatestRevCheck = true;
    };
  };

  catppuccin.k9s.enable = true;
}
