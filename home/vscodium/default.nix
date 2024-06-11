{
  config,
  lib,
  pkgs,
  ...
}:

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
      editorconfig.editorconfig
    ];
    userSettings = {
      "workbench.colorTheme" = "GitHub Dark";
      "editor.fontLigatures" = true;
      "editor.fontFamily" = lib.concatStringsSep ", " [
        "FiraCode Nerd Font"
        "Menlo"
        "Monaco"
        "'Courier New'"
        "monospace"
      ];
    };
  };

  programs.zsh.shellAliases = {
    code = "codium";
  };
}
