{ config, lib, ... }@args:
let
  secrets = args.secrets // builtins.fromTOML (builtins.readFile ../secrets.toml);
in {
  imports = map (m: lib.custom.relativeToHomeManagerModules m) [
    "accounts"
    "alacritty"
    "atuin"
    "bitwarden"
    "btop"
    "desktop-managers/gnome"
    "development"
    "discord"
    "doctl"
    "element"
    "firefox"
    "ghostty"
    "git"
    "gnupg"
    "gradia"
    "heroic"
    "impermanence"
    "jujutsu"
    "kubernetes"
    "lazygit"
    "libreoffice"
    "modern-unix"
    "mpv"
    "neovide"
    "neovim"
    "nextcloud-client"
    "nh"
    "ntfyd"
    "nushell"
    "planify"
    "proton-bridge"
    "qrrs"
    "signal-desktop"
    "steam"
    "systemctl-tui"
    "terraform"
    "thunderbird"
    "tools"
    "uutils"
    "velero"
    "vscodium"
    "whatsapp"
    "yazi"
    "zen-browser"
  ];

  nix.registry = {
    neovim.to = {
      path = "${config.home.homeDirectory}/code/github.com/daluca/nixvim-config";
      type = "path";
    };
  };

  services.ntfyd = {
    token = secrets.ntfy.token;
    topics = [
      "hosts"
    ];
  };

  sops.age.keyFile = lib.mkOverride 10 "/persistent/system/var/lib/sops-nix/key.txt";

  sops.secrets."gsconnect/private.pem".sopsFile = lib.custom.relativeToHosts "artemis/artemis.sops.yaml";

  programs.zsh.sessionVariables = {
    ZSH_TMUX_DEFAULT_SESSION_NAME = "artemis";
  };

  programs.zsh.history.path = lib.mkForce ("/persistent" + "${config.xdg.configHome}/zsh/zsh_history");
}
