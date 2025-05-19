{ config, lib, pkgs, hostname, inputs, outputs, ... }:

{
  imports =
    let
      hostExtras = (./. + "/${hostname}.nix");
    in builtins.attrValues outputs.homeManagerModules ++ [
      inputs.impermanence.homeManagerModules.default
      inputs.catppuccin.homeModules.default
    ] ++ map (m: lib.custom.relativeToHomeManagerModules m) [
      "ansible"
      "alacritty"
      "bitwarden"
      "btop"
      "direnv"
      "fonts"
      "ghostty"
      "git"
      "gron"
      "kubernetes"
      "lazygit"
      "logseq"
      "neovim"
      "qrrs"
      "starship"
      "tmux"
      "tools"
      "uutils"
      "vim"
      "vscodium"
      "zsh"
    ] ++ lib.optional (builtins.pathExists hostExtras) hostExtras;

  home = rec {
    username = "lucas.slebos";
    homeDirectory = "/home/${username}";
  };

  home.persistence.home.enable = lib.mkDefault false;

  home.packages = with pkgs; [
    nixgl.nixGLIntel
  ];

  programs.alacritty.package = lib.mkForce (pkgs.unstable.alacritty.overrideAttrs (_: {
    postFixup = /* bash */ ''
      ${pkgs.gnused}/bin/sed -i "s|^Exec=alacritty|Exec=nixGLIntel alacritty|" $out/share/applications/Alacritty.desktop
      chmod 0444 $out/share/applications/Alacritty.desktop
    '';
  }));

  programs.ghostty.package = lib.mkForce (pkgs.unstable.ghostty.overrideAttrs (oldAttrs: {
    postFixup = oldAttrs.postFixup + /* bash */ ''
      substituteInPlace $out/share/applications/com.mitchellh.ghostty.desktop \
        --replace Exec=ghostty "Exec=nixGLIntel ghostty"
    '';
  }));

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  targets.genericLinux.enable = true;

  programs.bash.enable = true;

  xdg.enable = true;

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
