{ config, pkgs, ... }:

{
  home.packages = with pkgs.unstable; [ element-desktop ];
}
