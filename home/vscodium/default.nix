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
      pkief.material-icon-theme
      tamasfe.even-better-toml
    ];
    userSettings = {
      "workbench.colorTheme" = "GitHub Dark";
      "workbench.iconTheme" = "material-icon-theme";
      "editor.fontLigatures" = true;
      "editor.fontFamily" = lib.concatStringsSep ", " [
        "FiraCode Nerd Font"
        "Menlo"
        "Monaco"
        "'Courier New'"
        "monospace"
      ];
      "editor.renderWhitespace" = "trailing";
      "files.associations" = {
        "flake.lock" = "json";
      };
    };
  };

  programs.zsh.shellAliases = {
    code = "codium";
  };
}
