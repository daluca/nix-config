{ config, pkgs, ... }:

{
  home.packages = with pkgs.unstable; [ kubernetes-helm ];
}
