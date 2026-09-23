{ self, inputs, ... }:

{
  flake.homeModules.vscodium = { lib, pkgs, ... }: {
    imports = with self.homeModules; [
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

    # NOTE: This is causing pnpm warnings
    # The issue has been resolved and is waiting to be backported
    # https://github.com/catppuccin/nix/pull/1016
    # NOTE: vscodium option does not work
    # Work around: set vscode option instead
    # https://github.com/catppuccin/nix/issues/1020
    catppuccin.vscode.profiles.default.enable = true;

    # NOTE: Remove once NixOS 26.11 version on catppuccin/nix is released
    # or the fix has been backported
    # https://github.com/catppuccin/nix/pull/1016
    catppuccin.sources = inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (
      _final: prev: {
        vscode = prev.vscode.overrideAttrs (oldAttrs: {
          nativeBuildInputs = [
            (pkgs.pnpm_10.override { nodejs-slim = pkgs.nodejs-slim_24; })
            pkgs.nodejs-slim_24
            pkgs.pnpmConfigHook
          ];

          pnpmDeps = pkgs.fetchPnpmDeps {
            inherit (oldAttrs)
              pname
              version
              src
              pnpmWorkspaces
              ;
            pnpm = pkgs.pnpm_10.override { nodejs-slim = pkgs.nodejs-slim_24; };
            fetcherVersion = 3;
            hash = "sha256-DE0mHkBlV0RkrEmtIXnzKaiXOK8vgcCx3z7b49zzBhc=";
          };
        });
      }
    );
  };

  flake.homeModules.vscodiumExtensions = {
    imports = with self.homeModules; [
      vscodiumExtensions-bash
      vscodiumExtensions-editorconfig
      vscodiumExtensions-materialIconTheme
      vscodiumExtensions-pdf
      vscodiumExtensions-pets
      vscodiumExtensions-typos
      vscodiumExtensions-vim
      vscodiumExtensions-nixIde
      vscodiumExtensions-evenBetterToml
      vscodiumExtensions-rustAnalyzer
      vscodiumExtensions-jsonnet
      vscodiumExtensions-helm
      vscodiumExtensions-todoHighlight
      vscodiumExtensions-tinymist
      vscodiumExtensions-ansible
      vscodiumExtensions-ipxe
      vscodiumExtensions-tera
    ];
  };

  flake.homeModules.vscodiumExtensions-bash = { lib, pkgs, ... }: {
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

  flake.homeModules.vscodiumExtensions-jujutsu =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
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

  flake.homeModules.vscodiumExtensions-just = { pkgs, ... }: {
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

  flake.homeModules.vscodiumExtensions-typos = { lib, pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        tekumara.typos-vscode
      ];
      userSettings = {
        "typos.path" = lib.getExe pkgs.typos-lsp;
      };
    };
  };

  flake.homeModules.vscodiumExtensions-pets = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        tonybaloney.vscode-pets
      ];
      userSettings = {
        "vscode-pets.position" = "explorer";
      };
    };
  };

  flake.homeModules.vscodiumExtensions-vim = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        vscodevim.vim
      ];
    };
  };

  flake.homeModules.vscodiumExtensions-materialIconTheme = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        pkief.material-icon-theme
      ];
      userSettings = {
        "workbench.iconTheme" = "material-icon-theme";
      };
    };
  };

  flake.homeModules.vscodiumExtensions-editorconfig = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        editorconfig.editorconfig
      ];
    };
  };

  flake.homeModules.vscodiumExtensions-direnv = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        mkhl.direnv
      ];
    };
  };

  flake.homeModules.vscodiumExtensions-pdf = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        tomoki1207.pdf
      ];
    };
  };

  flake.homeModules.vscodiumExtensions-opentofu = { lib, pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        opentofu.vscode-opentofu
      ];
      userSettings = {
        "opentofu.languageServer.path" = lib.getExe pkgs.tofu-ls;
      };
    };
  };

  flake.homeModules.vscodiumExtensions-nixIde = { lib, pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        jnoortheen.nix-ide
      ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${lib.getExe pkgs.nixd}";
        "nix.hiddenLanguageServerErrors" = [
          "textDocument/definition"
          "textDocument/documentSymbol"
        ];
        "files.associations" = {
          "flake.lock" = "json";
        };
      };
    };
  };

  flake.homeModules.vscodiumExtensions-evenBetterToml = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        tamasfe.even-better-toml
      ];
    };
  };

  flake.homeModules.vscodiumExtensions-rustAnalyzer = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        rust-lang.rust-analyzer
      ];
    };
  };

  flake.homeModules.vscodiumExtensions-jsonnet = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        grafana.vscode-jsonnet
      ];
    };
  };

  flake.homeModules.vscodiumExtensions-helm = { lib, pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        helm-ls.helm-ls
        ms-kubernetes-tools.vscode-kubernetes-tools
        redhat.vscode-yaml
      ];
      userSettings = {
        "helm-ls.path" = lib.getExe pkgs.helm-ls;
        "redhat.telemetry.enabled" = false;
      };
    };
  };

  flake.homeModules.vscodiumExtensions-todoHighlight = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        wayou.vscode-todo-highlight
      ];
    };
  };

  flake.homeModules.vscodiumExtensions-tinymist = { lib, pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        myriad-dreamin.tinymist
      ];
      userSettings = {
        "tinymist.serverPath" = lib.getExe pkgs.unstable.tinymist;
        "tinymist.exportPdf" = "onType";
      };
    };
  };

  flake.homeModules.vscodiumExtensions-ansible = { lib, pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions =
        with pkgs;
        with pkgs.open-vsx;
        [
          redhat.ansible
          samuelcolvin.jinjahtml
          redhat.vscode-yaml
          vscode-marketplace.ms-python.python
          vscode-marketplace.ms-python.vscode-python-envs
        ];
      userSettings = {
        "redhat.telemetry.enabled" = false;
        "ansible.python.interpreterPath" = lib.getExe pkgs.python3;
        "ansible.ansible.path" = lib.getExe' pkgs.ansible "ansible";
        "ansible.validation.lint.path" = lib.getExe pkgs.ansible-lint;
        "ansible.lightspeed.enabled" = false;
        "files.associations" = {
          "**/tasks/*.yaml" = "ansible";
          "**/tasks/*.yml" = "ansible";
          ".yamllint" = "yaml";
          ".ansible-lint" = "yaml";
        };
        "[ansible]" = {
          "editor.rulers" = [ 80 ];
        };
      };
    };
  };

  flake.homeModules.vscodiumExtensions-ipxe = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.open-vsx; [
        kipjr.vscode-language-ipxe
      ];
    };
  };

  flake.homeModules.vscodiumExtensions-tera = { pkgs, ... }: {
    programs.vscodium.profiles.default = {
      extensions = with pkgs.vscode-marketplace; [
        uncenter.better-tera
      ];
    };
  };
}
