{ config, lib, pkgs, outputs, ... }:
let
  inherit (builtins) replaceStrings attrValues;
  inherit (pkgs.unstable) nix-ld-rs;
  inherit (lib) lists attrsets;
  inherit (lists) unique;
  inherit (attrsets) filterAttrs;
in {
  imports = [
    ../dvorak
    ../home-manager
    ../secrets
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 28d";
  };

  programs.nix-ld = {
    enable = true;
    package = nix-ld-rs;
  };

  time.timeZone = "Pacific/Auckland";

  i18n = {
    defaultLocale = "en_NZ.UTF-8";
    supportedLocales = unique (builtins.map (locale: (replaceStrings ["utf8" "utf-8" "UTF8"] ["UTF-8" "UTF-8" "UTF-8"] locale) + "/UTF-8") (
    [
      "C.UTF-8"
      "en_GB.UTF-8"
      "en_US.UTF-8"
      "en_AU.UTF-8"
      config.i18n.defaultLocale
    ] ++ (attrValues (filterAttrs (n: v: n != "LANGUAGE") config.i18n.extraLocaleSettings))
    ));
  };

  hardware.pulseaudio.enable = true;
  sound.enable = true;
}
