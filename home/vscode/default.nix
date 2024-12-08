{ lib, pkgs, ... }:
let
  inherit (lib) getName;
  inherit (pkgs.unstable) vscode;
in {
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
      ms-kubernetes-tools.vscode-kubernetes-tools
      redhat.vscode-yaml
      hashicorp.terraform
      rust-lang.rust-analyzer
      helm-ls.helm-ls
      grafana.vscode-jsonnet
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
