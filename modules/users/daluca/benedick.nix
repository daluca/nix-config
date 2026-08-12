{ self, ... }:

{
  flake.homeManagerModules.users-daluca-benedick = { config, lib, pkgs, ... }: {
    imports = with self.homeManagerModules; [
      users-daluca

      development
      faugusLauncher
      ghostty
      git
      gnupg
      jujutsu
      libreoffice
      mangohud
      neovim
      nix-utils
      zenBrowser
      vscodium
      games
      autostart
    ];

    programs.custom-firefox.default = "zen-browser";

    programs.tmux.extraConfig = /* tmux */ ''
      bind C-j display-popup -d "#{pane_current_path}" -w 90% -h 90% -E ${lib.getExe config.programs.jjui.package}
      bind C-t display-popup -d "#{pane_current_path}" -w 60% -h 60% -E ${lib.getExe config.programs.zsh.package}
      bind C-s display-popup -w 90% -h 90% -E ${lib.getExe pkgs.lazyssh}
    '';

    programs.btop.package = lib.mkForce pkgs.btop-rocm;

    sops.age.keyFile = lib.mkOverride 10 ("/persistent" + "${config.xdg.configHome}/sops/age/keys.txt");

    sops.secrets."gsconnect/private.pem".sopsFile = ../../hosts/benedick/benedick.sops.yaml;
  };
}
