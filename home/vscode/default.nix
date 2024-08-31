{ lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.unstable.vscode-extensions; [
      vscodevim.vim
      eamodio.gitlens
      github.github-vscode-theme
      pkief.material-icon-theme
      jnoortheen.nix-ide
      editorconfig.editorconfig
      skellock.just
      tamasfe.even-better-toml
    ] ++ pkgs. vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "helm-ls";
        publisher = "helm-ls";
        version = "1.0.0";
        hash = "sha256-44CkW/TX9BfoMD+082n2f77TMkA6GdH9BRtRimDRLjc=";
      }
    ];
    userSettings = {
      # Editor
      "editor.rulers" = [ 80 ];
      "editor.renderWhitespace" = "trailing";
      "editor.fontLigatures" = true;
      "editor.fontFamily" = lib.concatStringsSep ", " [
        "FiraCode Nerd Font"
        "Menlo"
        "Monaco"
        "'Courier New'"
        "monospace"
      ];
      # Files
      "files.associations" = {
        "flake.lock" = "json";
      };
      # Theme
      "workbench.colorTheme" = "GitHub Dark";
      "workbench.iconTheme" = "material-icon-theme";
      # Trusted
      "security.workspace.trust.enabled" = false;
      # Welcome
      "update.showReleaseNotes" = false;
      "workbench.startupEditor" = "none";
      "workbench.welcomePage.extraAnnouncements" = false;
      "workbench.welcomePage.walkthroughs.openOnInstall" = false;
      # GitLens
      "gitlens.showWelcomeOnInstall" = false;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
  ];
}