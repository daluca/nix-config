{ config, lib, pkgs, inputs, outputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ] ++ builtins.attrValues outputs.nixosModules ++ map (m: lib.custom.relativeToNixosModules m) [
    "dvorak"
    "home-manager"
    "openssh"
    "secrets"
    "networking"
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "root"
    "daluca"
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    download-buffer-size = 256 * 1024 * 1024; # 256MiB
  };

  nixpkgs.overlays = builtins.attrValues outputs.overlays ++ [
    inputs.nur.overlays.default
    inputs.nix-vscode-extensions.overlays.default
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ([
    "discord"
    "vscode"
    "nvidia-x11"
    "nvidia-settings"
  ] ++ lib.optionals config.programs.steam.enable [
    "steam"
    "steam-unwrapped"
  ] ++ lib.optionals config.services.unifi.enable [
    "unifi-controller"
    "mongodb-ce"
  ] ++ lib.optionals config.services.sabnzbd.enable [
    "unrar"
  ]);

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
    package = pkgs.nix-ld-rs;
  };

  time.timeZone = lib.mkDefault "Etc/UTC";

  i18n = {
    defaultLocale = "en_NZ.UTF-8";
    supportedLocales = lib.unique (map (locale: (builtins.replaceStrings ["utf8" "utf-8" "UTF8"] ["UTF-8" "UTF-8" "UTF-8"] locale) + "/UTF-8") (
    [
      "C.UTF-8"
      "en_GB.UTF-8"
      "en_US.UTF-8"
      "en_AU.UTF-8"
      config.i18n.defaultLocale
    ] ++ (builtins.attrValues (lib.filterAttrs (n: _v: n != "LANGUAGE") config.i18n.extraLocaleSettings))
    ));
  };

  users.mutableUsers = false;

  environment.persistence.system.enable = lib.mkDefault false;

  services.pulseaudio.enable = true;
}
