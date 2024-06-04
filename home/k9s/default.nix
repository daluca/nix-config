{ config, pkgs, ... }:

{
  programs.k9s = {
    enable = false;
    package = pkgs.unstable.k9s;
  };
}
