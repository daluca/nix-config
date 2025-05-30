{ lib, ... }:

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
    "proton-bridge"
    "whatsapp"
    "qrrs"
    "ghostty"
    "yazi"
    "nh"
    "modern-unix"
    "atuin"
  ];

  sops.secrets."gsconnect/private.pem".sopsFile = lib.custom.relativeToHosts "artemis/artemis.sops.yaml";

  programs.zsh.sessionVariables = {
    ZSH_TMUX_DEFAULT_SESSION_NAME = "artemis";
  };
}
