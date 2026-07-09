{ pkgs, ... }:

{
  programs.gpg.publicKeys = [
    {
      source = ./0x7626A2AB23757525-2026-07-09.asc;
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
