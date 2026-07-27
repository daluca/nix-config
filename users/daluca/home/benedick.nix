{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports =
    with inputs.self.homeManagerModules;
    [
      ultrawide-wallpaper
      nix-utils
    ]
    ++ map (m: lib.custom.relativeToHomeManagerModules m) [
      "desktop-environments/gnome"
      "development"
      "faugus-launcher"
      "ghostty"
      "git"
      "gnupg"
      "impermanence"
      "jujutsu"
      "neovim"
      "steam"
      "vscodium"
      "zen-browser"
    ];

  programs.tmux.extraConfig = /* tmux */ ''
    bind C-j display-popup -d "#{pane_current_path}" -w 90% -h 90% -E ${lib.getExe config.programs.jjui.package}
    bind C-t display-popup -d "#{pane_current_path}" -w 60% -h 60% -E ${lib.getExe config.programs.zsh.package}
    bind C-s display-popup -w 90% -h 90% -E ${lib.getExe pkgs.lazyssh}
  '';

  programs.btop.package = lib.mkForce pkgs.btop-rocm;

  sops.age.keyFile = lib.mkOverride 10 ("/persistent" + "${config.xdg.configHome}/sops/age/keys.txt");

  sops.secrets."gsconnect/private.pem".sopsFile =
    lib.custom.relativeToHosts "benedick/benedick.sops.yaml";
}
