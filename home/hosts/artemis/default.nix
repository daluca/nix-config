{ config, osConfig, outputs, ... }:

{
  imports = [
    outputs.homeManagerModules.themes

    ../../desktop-managers/gnome

    ../../common
    ../../impermanence
    ../../tools

    ../../firefox
    ../../alacritty
    ../../doctl

    ../../development
    ../../kubernetes
    ../../vscodium
    ../../btop
    ../../direnv
    ../../mpv
    ../../uutils
    ../../thunderbird
    ../../gnupg
    ../../bitwarden
    ../../libreoffice
    ../../nextcloud-client
    ../../opensnitch
    ../../velero
    ../../terraform
    ../../element
    ../../steam
    ../../neovim
    ../../nushell
    ../../heroic
  ];

  themes.catppuccin.flavour = "Mocha";

  sops.secrets."gsconnect/private.pem".sopsFile = ../../../secrets/artemis.sops.yaml;

  programs.zsh.sessionVariables = {
    ZSH_TMUX_AUTOSTART = "true";
    ZSH_TMUX_DEFAULT_SESSION_NAME = "${osConfig.networking.hostName}";
    ZSH_TMUX_CONFIG = "${config.xdg.configHome}/tmux/tmux.conf";
  };
}
