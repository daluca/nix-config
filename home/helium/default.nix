{ pkgs, ... }:

{
  home.packages = with pkgs; [
    helium
  ];
}
