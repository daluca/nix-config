{ lib, osConfig, inputs, outputs, ... }:
let
  inherit (osConfig.networking) hostName;
in {
  imports =
    let
      hostExtras = (./. + "/${hostName}.nix");
    in with inputs; builtins.attrValues outputs.homeManagerModules ++ [
      outputs.nixosModules.host
      impermanence.homeManagerModules.impermanence
    ] ++ map (m: lib.custom.relativeToHomeManagerModules m) [
      "bash"
      "btop"
      "catppuccin"
      "dvorak"
      "ntfy"
      "openssh"
      "secrets"
      "starship"
      "tmux"
      "tools"
      "vim"
      "zsh"
    ] ++ lib.optional (builtins.pathExists hostExtras) hostExtras;

  home = rec {
    username = "daluca";
    homeDirectory = "/home/${username}";
  };

  sops.secrets."ntfy/token".sopsFile = ../daluca.sops.yaml;

  home.persistence.home.enable = lib.mkDefault false;

  xdg.enable = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
