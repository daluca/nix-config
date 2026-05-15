{
  config,
  lib,
  osConfig,
  outputs,
  ...
}:
let
  inherit (osConfig.networking) hostName;
in
{
  imports =
    let
      hostExtras = (./. + "/${hostName}.nix");
    in
    with outputs.homeManagerModules;
    [
      outputs.nixosModules.host
    ]
    ++ [
      garden-tools
      kanata
      ntfyd
    ]
    ++ map (m: lib.custom.relativeToHomeManagerModules m) [
      "atuin"
      "bash"
      "btop"
      "catppuccin"
      "ntfy"
      "openssh"
      "secrets"
      "starship"
      "tmux"
      "tools"
      "vim"
      "zsh"
    ]
    ++ lib.optional (builtins.pathExists hostExtras) hostExtras;

  home = rec {
    username = "daluca";
    homeDirectory = "/home/${username}";
  };

  home.persistence.home = {
    enable = lib.mkDefault false;
    persistentStoragePath = "/persistent/";
  };

  nix.extraOptions = ''
    !include ${config.sops.templates."github-access-token.conf".path}
  '';

  sops.templates."github-access-token.conf".content = ''
    access-tokens = github.com=${config.sops.placeholder."github/access-token"}
  '';

  sops.secrets."github/access-token" = { };

  xdg.enable = true;

  xdg.terminal-exec = {
    enable = true;
    settings.default = [
      "com.mitchellh.ghostty.desktop"
    ];
  };

  home.shellAliases = {
    open = "xdg-open";
  };

  home.preferXdgDirectories = true;

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
