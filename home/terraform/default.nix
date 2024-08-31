{ config, lib, inputs, system, ... }:

{
  home.packages = with inputs.terraform-oss.legacyPackages.${system}.pkgs; [
    terraform
  ];

  programs.zsh.oh-my-zsh.plugins = lib.mkIf ( config.programs.zsh.enable && config.programs.zsh.oh-my-zsh.enable ) [
    "terraform"
  ];
}
