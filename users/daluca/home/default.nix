{ lib, osConfig, inputs, outputs, ... }:
let
  inherit (osConfig.networking) hostName;
in {
  imports =
    let
      hostExtras = (./. + "/${hostName}.nix");
    in builtins.attrValues outputs.homeManagerModules ++ [
      outputs.nixosModules.host
      inputs.impermanence.homeManagerModules.impermanence
    ] ++ map (m: lib.custom.relativeToHomeManagerModules m) [
      "bash"
      "btop"
      "catppuccin"
      "dvorak"
      "openssh"
      "secrets"
      "starship"
      "tmux"
      "tools"
      "vim"
      "zsh"
    ] ++ lib.optionals (osConfig.environment.persistence.system.enable) map (m: lib.custom.relativeToHomeManagerModules m) [
      "impermanence"
    ] ++ lib.optional (builtins.pathExists hostExtras) hostExtras;

  home = rec {
    username = "daluca";
    homeDirectory = "/home/${username}";
  };

  home.persistence.home.enable = lib.mkDefault false;

  xdg.enable = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
