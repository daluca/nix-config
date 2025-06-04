{ lib, pkgs, ... }:

{
  imports = [
    ./extensions
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;
    mutableExtensionsDir = false;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.open-vsx; [
        vscodevim.vim
        github.github-vscode-theme
        pkief.material-icon-theme
        editorconfig.editorconfig
        skellock.just
        tamasfe.even-better-toml
        hashicorp.terraform
        rust-lang.rust-analyzer
        grafana.vscode-jsonnet
        tomoki1207.pdf
        mkhl.direnv
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
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;
        "files.exclude" = {
          "**/.jj" = true;
        };
        # Git
        "git.autofetch" = true;
        "git.blame.editorDecoration.enabled" = true;
        "workbench.colorCustomizations" = {
          "git.blame.editorDecorationForeground" = "#444d56";
        };
        # Telemetry
        "telemetry.telemetryLevel" = "off";
        "redhat.telemetry.enabled" = false;
        # Terminal
        "terminal.integrated.defaultProfile.linux" = "zsh";
        # Theme
        "workbench.colorTheme" = "GitHub Dark";
        "workbench.iconTheme" = "material-icon-theme";
        # Trusted
        "security.workspace.trust.enabled" = false;
        "workbench.trustedDomains.promptInTrustedWorkspace" = false;
        # Welcome
        "update.showReleaseNotes" = false;
        "workbench.startupEditor" = "none";
        "workbench.welcomePage.extraAnnouncements" = false;
        "workbench.welcomePage.walkthroughs.openOnInstall" = false;
      };
    };
  };
}
