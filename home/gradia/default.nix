{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gradia
  ];
}
