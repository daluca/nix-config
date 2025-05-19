{ config, lib, pkgs, hostname, inputs, outputs, ... }:

{
  imports =
    let
      hostExtras = (./. + "/${hostname}.nix");
    in builtins.attrValues outputs.homeManagerModules ++ [
      inputs.impermanence.homeManagerModules.default
      inputs.catppuccin.homeModules.default
    ] ++ map (m: lib.custom.relativeToHomeManagerModules m) [
      "ansible"
      "bitwarden"
      "btop"
      "direnv"
      "fonts"
      "git"
      "gron"
      "kubernetes"
      "lazygit"
      "logseq"
      "neovim"
      "qrrs"
      "starship"
      "tmux"
      "tools"
      "uutils"
      "vim"
      "vscodium"
      "zsh"
    ] ++ lib.optional (builtins.pathExists hostExtras) hostExtras;

  home = rec {
    username = "lucas.slebos";
    homeDirectory = "/home/${username}";
  };

  home.persistence.home.enable = lib.mkDefault false;

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  targets.genericLinux.enable = true;

  programs.bash.enable = true;

  xdg.enable = true;

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
