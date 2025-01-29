{ config, lib, pkgs, outputs, ... }:
let
  inherit (pkgs) nix-ld-rs;
  inherit (lib) lists attrsets;
  inherit (lists) unique;
  inherit (attrsets) filterAttrs;
in {
  imports = [
    ../dvorak
    ../home-manager
    ../secrets
    ../networking
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    download-buffer-size = 256 * 1024 * 1024; # 256MiB
  };

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "45 minutes";
    options = "--delete-older-than 28d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "daily" ];
  };

  programs.nix-ld = {
    enable = true;
    package = nix-ld-rs;
  };

  time.timeZone = "Pacific/Auckland";

  i18n = {
    defaultLocale = "en_NZ.UTF-8";
    supportedLocales = unique (builtins.map (locale: (builtins.replaceStrings ["utf8" "utf-8" "UTF8"] ["UTF-8" "UTF-8" "UTF-8"] locale) + "/UTF-8") (
    [
      "C.UTF-8"
      "en_GB.UTF-8"
      "en_US.UTF-8"
      "en_AU.UTF-8"
      config.i18n.defaultLocale
    ] ++ (builtins.attrValues (filterAttrs (n: v: n != "LANGUAGE") config.i18n.extraLocaleSettings))
    ));
  };

  hardware.pulseaudio.enable = true;
}
