{ lib, osConfig, inputs, outputs, ... }:
let
  inherit (osConfig.networking) hostName;
in {
  imports =
    let
      hostExtras = (./. + "/${hostName}.nix");
    in builtins.attrValues outputs.homeManagerModules ++ [
      inputs.impermanence.homeManagerModules.impermanence
    ] ++ map (m: lib.custom.relativeToHomeManagerModules m) [
      "tmux"
      "dvorak"
      "zsh"
      "starship"
      "openssh"
      "secrets"
      "catppuccin"
      "tools"
      "btop"
      "vim"
    ] ++ lib.optional (builtins.pathExists hostExtras) hostExtras;

  home = rec {
    username = "daluca";
    homeDirectory = "/home/${username}";
  };

  home.persistence.home.enable = lib.mkDefault false;

  themes.catppuccin.flavour = "Mocha";

  programs.bash.enable = true;

  xdg.enable = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
