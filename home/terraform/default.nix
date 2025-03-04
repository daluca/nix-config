{ inputs, system, ... }:

{
  home.packages = with inputs.terraform-oss.legacyPackages.${system}.pkgs; [
    terraform
  ];

  programs.zsh.oh-my-zsh.plugins = [
    "terraform"
  ];
}
