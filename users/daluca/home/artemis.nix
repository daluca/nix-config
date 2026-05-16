{
  config,
  lib,
  pkgs,
  ...
}@args:
let
  secrets = args.secrets // fromTOML (builtins.readFile ../secrets.toml);
in
{
  imports = map (m: lib.custom.relativeToHomeManagerModules m) [
    "accounts"
    "alacritty"
    "anki"
    "atuin"
    "bitwarden"
    "btop"
    "desktop-environments/gnome"
    "development"
    "discord"
    "doctl"
    "element"
    "faugus-launcher"
    "feishin"
    "firefox"
    "ghostty"
    "git"
    "gnupg"
    "gradia"
    "helium"
    "heroic"
    "impermanence"
    "intiface-central"
    "itch"
    "jujutsu"
    "kubernetes"
    "lazygit"
    "lazyssh"
    "libreoffice"
    "modern-unix"
    "mpv"
    "neovide"
    "neovim"
    "nextcloud-client"
    "nh"
    "nix-utils"
    "ntfyd"
    "nushell"
    "planify"
    "protonmail-bridge"
    "proton-vpn"
    "qrrs"
    "signal-desktop"
    "steam"
    "systemctl-tui"
    "thunderbird"
    "tools"
    "uutils"
    "velero"
    "vscodium"
    "whatsapp"
    "yazi"
    "zen-browser"
  ];

  programs.tmux.extraConfig = /* tmux */ ''
    bind C-j display-popup -d "#{pane_current_path}" -w 90% -h 90% -E ${lib.getExe config.programs.jjui.package}
    bind C-t display-popup -d "#{pane_current_path}" -w 60% -h 60% -E ${lib.getExe config.programs.zsh.package}
    bind C-s display-popup -w 90% -h 90% -E ${lib.getExe pkgs.lazyssh}
  '';

  nix.registry = {
    neovim.to = {
      path = "${config.home.homeDirectory}/code/github.com/daluca/nixvim-config";
      type = "path";
    };
  };

  xdg.mimeApps.enable = true;

  services.ntfyd = {
    token = secrets.ntfy.token;
    topics = [
      "hosts"
      "gatus"
    ];
  };

  sops.age.keyFile = lib.mkOverride 10 ("/persistent" + "${config.xdg.configHome}/sops/age/keys.txt");

  sops.secrets."gsconnect/private.pem".sopsFile =
    lib.custom.relativeToHosts "artemis/artemis.sops.yaml";

  programs.zsh.sessionVariables = {
    ZSH_TMUX_DEFAULT_SESSION_NAME = "artemis";
  };
}
