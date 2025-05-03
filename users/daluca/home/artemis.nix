{ config, lib, ... }:

{
  imports = map (m: lib.custom.relativeToHomeManagerModules m) [
    "desktop-managers/gnome"
    "impermanence"
    "tools"
    "firefox"
    "alacritty"
    "doctl"
    "git"
    "development"
    "kubernetes"
    "vscodium"
    "btop"
    "direnv"
    "mpv"
    "uutils"
    "thunderbird"
    "gnupg"
    "bitwarden"
    "libreoffice"
    "nextcloud-client"
    "velero"
    "terraform"
    "element"
    "steam"
    "neovim"
    "nushell"
    "heroic"
    "signal-desktop"
    "discord"
    "lazygit"
    "accounts"
    "gaming"
    "proton-bridge"
    "whatsapp"
  ];

  sops.secrets."gsconnect/private.pem".sopsFile = lib.custom.relativeToHosts "artemis/artemis.sops.yaml";

  programs.zsh.sessionVariables = {
    ZSH_TMUX_AUTOSTART = "true";
    ZSH_TMUX_DEFAULT_SESSION_NAME = "artemis";
    ZSH_TMUX_CONFIG = "${config.xdg.configHome}/tmux/tmux.conf";
  };
}
