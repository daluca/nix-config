{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscodium;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.unstable.vscode-extensions; [
      vscodevim.vim
      jnoortheen.nix-ide
      github.github-vscode-theme
    ];
    userSettings = {
      workbench.colorTheme = "GitHub Dark";
    };
  };

  programs.zsh.shellAliases = {
    code = "codium";
  };
}
