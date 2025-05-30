{ pkgs, ... }:

{
  programs.git = {
    delta = {
      enable = true;
      package = pkgs.unstable.delta;
      options = {
        line-numbers = true;
      };
    };
  };

  catppuccin.delta.enable = true;
}
