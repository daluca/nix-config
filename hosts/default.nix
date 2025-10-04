{ config, lib, pkgs, secrets, inputs, outputs, ... }:
let
  GiB = 1024 * 1024 * 1024;
in {
  imports = with inputs; (
    builtins.filter (f: baseNameOf f == "cache.nix") (lib.filesystem.listFilesRecursive (lib.custom.relativeToHosts "."))
  ) ++ [
    impermanence.nixosModules.impermanence
    catppuccin.nixosModules.catppuccin
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

  catppuccin.cache.enable = true;

  sops.secrets."ssh_host_ed25519_key" = { };

  sops.secrets."ssh_host_rsa_key" = { };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://nix-community.cachix.org"
      "https://attic.${secrets.domain.general}/production"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "production:fGtC1cQt7NrvIl7VD8nqnYsICCYK5CKQdxuZiYp+Q40="
    ];
    download-buffer-size = 1 * GiB;
    trusted-users = [ "@wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = with inputs; builtins.attrValues outputs.overlays ++ [
    nur.overlays.default
    nix-vscode-extensions.overlays.default
    proton-ge.overlays.default
  ];

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

  time.timeZone = lib.mkDefault "UTC";

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
