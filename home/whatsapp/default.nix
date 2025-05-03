{ pkgs, ... }:

{
  home.packages = with pkgs; [
    whatsapp-for-linux
  ];

  home.persistence.home.directories = [
    ".local/share/whatsapp-for-linux"
  ];
}
