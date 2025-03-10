{ config, lib, osConfig, ... }:
let
  inherit (config.xdg) configHome;
  inherit (osConfig.networking) hostName;
in {
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
  ];

  sops.secrets."id_ed25519" = {
    sopsFile = ../daluca.sops.yaml;
    path = ".ssh/id_ed25519";
  };

  sops.secrets."gsconnect/private.pem".sopsFile = ../../../hosts/artemis/artemis.sops.yaml;

  home.file.".ssh/id_ed25519.pub".source = ../keys/id_ed25519.pub;

  programs.zsh.sessionVariables = {
    ZSH_TMUX_AUTOSTART = "true";
    ZSH_TMUX_DEFAULT_SESSION_NAME = "${hostName}";
    ZSH_TMUX_CONFIG = "${configHome}/tmux/tmux.conf";
  };
}
