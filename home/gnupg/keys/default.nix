{ pkgs, ... }:

{
  programs.gpg.publicKeys = [
    {
      source = ./7626A2AB23757525-2024-07-03.asc;
      trust = "ultimate";
    }
    {
      source = pkgs.fetchurl {
        url = "https://github.com/web-flow.gpg";
        hash = "sha256-bor2h/YM8/QDFRyPsbJuleb55CTKYMyPN4e9RGaj74Q=";
      };
      trust = "full";
    }
  ];
}
