{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = with inputs.self.homeManagerModules; [
    nix-utils
  ] ++ map (m: lib.custom.relativeToHomeManagerModules m) [
    "desktop-environments/gnome"
    "development"
    "faugus-launcher"
    "ghostty"
    "git"
    "gnupg"
    "impermanence"
    "jujutsu"
    "neovim"
    "steam"
    "vscodium"
    "zen-browser"
  ];

  programs.btop.package = lib.mkForce pkgs.btop-rocm;

  sops.age.keyFile = lib.mkOverride 10 ("/persistent" + "${config.xdg.configHome}/sops/age/keys.txt");

  sops.secrets."gsconnect/private.pem".sopsFile = lib.custom.relativeToHosts "benedick/benedick.sops.yaml";
}
