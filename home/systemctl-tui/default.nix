{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    systemctl-tui
  ];
}
