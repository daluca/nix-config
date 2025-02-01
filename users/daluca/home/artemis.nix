{ config, osConfig, ... }:
let
  inherit (config.xdg) configHome;
  inherit (osConfig.networking) hostName;
in {
  imports = [
    ../../../home/common
    ../../../home/desktop-managers/gnome
    ../../../home/impermanence
    ../../../home/tools
    ../../../home/firefox
    ../../../home/alacritty
    ../../../home/doctl
    ../../../home/git
    ../../../home/development
    ../../../home/kubernetes
    ../../../home/vscodium
    ../../../home/btop
    ../../../home/direnv
    ../../../home/mpv
    ../../../home/uutils
    ../../../home/thunderbird
    ../../../home/gnupg
    ../../../home/bitwarden
    ../../../home/libreoffice
    ../../../home/nextcloud-client
    ../../../home/velero
    ../../../home/terraform
    ../../../home/element
    ../../../home/steam
    ../../../home/neovim
    ../../../home/nushell
    ../../../home/heroic
    ../../../home/signal-desktop
    ../../../home/discord
    ../../../home/lazygit
    ../../../home/accounts
    ../../../home/gaming
    ../../../home/proton-bridge
    # ../../../home/opensnitch
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
