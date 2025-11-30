{ config, ... }:

{
  programs.garden-tools = {
    enable = true;
    settings = {
      garden.root = "${config.home.homeDirectory}/code";

      trees = {
        cloud = {
          url = "github:daluca/cloud";
          path = "github.com/daluca/cloud";
        };
        cv = {
          url = "github:daluca/cv";
          path = "github.com/daluca/cv";
        };
        first-bevy-game = {
          url = "github:daluca/first-bevy-game";
          path = "github.com/daluca/first-bevy-game";
        };
        helm-charts = {
          url = "github:daluca/helm-charts";
          path = "github.com/daluca/helm-charts/main";
        };
        nix-config = {
          url = "github:daluca/nix-config";
          path = "github.com/daluca/nix-config";
        };
        nixvim-config = {
          url = "github:daluca/nixvim-config";
          path = "github.com/daluca/nixvim-config";
        };
        proton-ge-overlay = {
          url = "github:daluca/proton-ge-overlay";
          path = "github.com/daluca/proton-ge-overlay";
        };
      };

      groups = {
        personal = [
          "cloud"
          "cv"
          "first-bevy-game"
          "helm-charts"
          "nix-config"
          "nixvim-config"
          "proton-ge-overlay"
        ];
      };

      gardens = {
        all.groups = [
          "personal"
        ];
      };

      commands = {
        git = "git \"$@\"";
        status = "git status --short \"$@\"";
      };
    };
  };

  home.shellAliases = {
    g = "garden";
  };
}
