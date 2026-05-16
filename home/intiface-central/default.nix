{ pkgs, ... }:

{
  home.packages = with pkgs; [
    intiface-central
  ];

  home.persistence.home.directories = [
    ".local/share/com.nonpolynomial.intiface_central"
  ];
}
