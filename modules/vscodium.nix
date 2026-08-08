{ self, ... }:

{
  flake.homeManagerModules.vscodium = { lib, pkgs, ... }: {
    imports = with self.homeManagerModules; [
      vscodiumExtensions
    ];

    programs.vscodium = {
      enable = true;
      package = pkgs.unstable.vscodium;
      mutableExtensionsDir = false;
      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        userSettings = {
          # Editor
          "editor.rulers" = [ 80 ];
          "editor.renderWhitespace" = "trailing";
          "editor.fontFamily" = lib.concatStringsSep ", " [
            "Monaspace Argon Var"
            "Symbols Nerd Font"
          ];
          "editor.fontLigatures" = lib.concatStringsSep ", " [
            "'calt'"
            "'ss01'"
            "'ss02'"
            "'ss03'"
            "'ss04'"
            "'ss05'"
            "'ss06'"
            "'ss07'"
            "'ss08'"
            "'ss09'"
            "'ss10'"
            "'liga'"
          ];
          # Files
          "files.trimTrailingWhitespace" = true;
          "files.insertFinalNewline" = true;
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
          # Trusted
          "security.workspace.trust.enabled" = false;
          "workbench.trustedDomains.promptInTrustedWorkspace" = false;
          # Welcome
          "update.showReleaseNotes" = false;
          "workbench.startupEditor" = "none";
          "workbench.welcomePage.extraAnnouncements" = false;
          "workbench.welcomePage.walkthroughs.openOnInstall" = false;
          # Windows
          "workbench.secondarySideBar.defaultVisibility" = "hidden";
          # AI
          "chat.disableAIFeatures" = true;
          "chat.agent.enabled" = false;
        };
      };
    };

    home.shellAliases = {
      code = "codium";
    };

    catppuccin.vscodium.profiles.default.enable = true;
  };

  flake.homeManagerModules.vscodiumExtensions = {
    imports = with self.homeManagerModules; [
      vscodiumExtensions-bash
      vscodiumExtensions-editorconfig
      vscodiumExtensions-materialIconTheme
      vscodiumExtensions-pdf
      vscodiumExtensions-pets
      vscodiumExtensions-typos
      vscodiumExtensions-vim
    ];
  };

  flake.homeManagerModules.vscodiumExtensions-bash = { lib, pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        mads-hartmann.bash-ide-vscode
      ];
      userSettings = {
        "bashIde.shellcheckPath" = lib.getExe pkgs.shellcheck;
        "bashIde.shfmt.path" = lib.getExe pkgs.shfmt;
      };
    };
  };

  flake.homeManagerModules.vscodiumExtensions-jujutsu = { config, lib, pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        jjk.jjk
      ];
      userSettings = {
        "git.enabled" = lib.mkForce false;
        "jjk.jjPath" = lib.getExe config.programs.jujutsu.package;
        "files.exclude" = {
          "**/.jj" = true;
        };
      };
    };
  };

  flake.homeManagerModules.vscodiumExtensions-just = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        skellock.just
      ];
      userSettings = {
        "files.associations" = {
          "**.just" = "just";
        };
      };
    };
  };

  flake.homeManagerModules.vscodiumExtensions-typos = { lib, pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        tekumara.typos-vscode
      ];
      userSettings = {
        "typos.path" = lib.getExe pkgs.typos-lsp;
      };
    };
  };

  flake.homeManagerModules.vscodiumExtensions-pets = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        tonybaloney.vscode-pets
      ];
      userSettings = {
        "vscode-pets.position" = "explorer";
      };
    };
  };

  flake.homeManagerModules.vscodiumExtensions-vim = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        vscodevim.vim
      ];
    };
  };

  flake.homeManagerModules.vscodiumExtensions-materialIconTheme = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        pkief.material-icon-theme
      ];
      userSettings = {
        "workbench.iconTheme" = "material-icon-theme";
      };
    };
  };

  flake.homeManagerModules.vscodiumExtensions-editorconfig = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        editorconfig.editorconfig
      ];
    };
  };

  flake.homeManagerModules.vscodiumExtensions-direnv = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        mkhl.direnv
      ];
    };
  };

  flake.homeManagerModules.vscodiumExtensions-pdf = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        tomoki1207.pdf
      ];
    };
  };

  flake.homeManagerModules.vscodiumExtensions-opentofu = { lib, pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        opentofu.vscode-opentofu
      ];
      userSettings = {
        "opentofu.languageServer.path" = lib.getExe pkgs.tofu-ls;
      };
    };
  };
}
