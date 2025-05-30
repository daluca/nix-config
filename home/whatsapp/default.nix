{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wasistlos
  ];

  home.persistence.home.directories = [
    ".local/share/wasistlos"
  ];
}
