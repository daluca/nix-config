{ pkgs, ... }:

{
  home.packages = with pkgs; [ doctl ];

  home.persistence.home.directories = [
    ".config/doctl"
  ];
}
