{ pkgs, ... }:

{
  home.packages = with pkgs; [
    planify
  ];

  home.persistence.home.directories = [
    ".local/share/io.github.alainm23.planify"
  ];
}
