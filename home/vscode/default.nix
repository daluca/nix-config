{ lib, pkgs, ... }:
let
  inherit (lib) getName;
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
      eamodio.gitlens
      github.github-vscode-theme
      pkief.material-icon-theme
      jnoortheen.nix-ide
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
      "files.exclude" = {
        "**/.jj" = true;
      };
      # Telemetry
      "telemetry.telemetryLevel" = "off";
      "redhat.telemetry.enabled" = false;
      "gitlens.telemetry.enabled" = false;
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

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
    "vscode"
  ];
}
