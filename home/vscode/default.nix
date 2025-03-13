{ lib, pkgs, ... }:
let
  inherit (lib) concatStringsSep;
  inherit (lib.lists) flatten;
  inherit (pkgs.unstable) vscode;
  vscode-kubernetes-tools = with pkgs.open-vsx; [
    ms-kubernetes-tools.vscode-kubernetes-tools
  ] ++ /* Dependencies */ [
    redhat.vscode-yaml
  ];
  helm-ls' = with pkgs.open-vsx; [
    helm-ls.helm-ls
  ] ++ /* Dependencies */ [
    vscode-kubernetes-tools
  ];
in {
  imports = [
    ./extensions
  ];

  programs.vscode = {
    enable = true;
    package = vscode;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
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
    ] ++ flatten [
      vscode-kubernetes-tools
      helm-ls'
    ];
    userSettings = {
      # Editor
      "editor.rulers" = [ 80 ];
      "editor.renderWhitespace" = "trailing";
      "editor.fontLigatures" = true;
      "editor.fontFamily" = concatStringsSep ", " [
        "FiraCode Nerd Font"
        "Menlo"
        "Monaco"
        "'Courier New'"
        "monospace"
      ];
      # Files
      "files.exclude" = {
        "**/.jj" = true;
      };
      # Git
      "git.autofetch" = true;
      # Telemetry
      "telemetry.telemetryLevel" = "off";
      "redhat.telemetry.enabled" = false;
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
    };
  };
}
