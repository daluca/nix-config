{ lib, osConfig, inputs, outputs, ... }:
let
  inherit (osConfig.networking) hostName;
in {
  imports =
    let
      hostExtras = (./. + "/${hostName}.nix");
    in builtins.attrValues outputs.homeManagerModules ++ [
      inputs.impermanence.homeManagerModules.impermanence

      ../../../home/tmux
      ../../../home/dvorak
      ../../../home/zsh
      ../../../home/starship
      ../../../home/openssh
      ../../../home/secrets
      ../../../home/catppuccin
      ../../../home/tools
      ../../../home/btop
      ../../../home/vim
    ] ++ lib.optional (builtins.pathExists hostExtras) hostExtras;

  home = rec {
    username = "daluca";
    homeDirectory = "/home/${username}";
  };

  home.persistence.home.enable = lib.mkDefault false;

  themes.catppuccin.flavour = "Mocha";

  programs.bash.enable = true;

  xdg.enable = true;

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
