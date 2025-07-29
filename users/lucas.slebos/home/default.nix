{ config, lib, pkgs, hostname, inputs, outputs, ... }@args:
let
  secrets = args.secrets // builtins.fromTOML (builtins.readFile ../secrets.toml);

  additionalBookmarks = [
    {
      name = "Odoo (ERP)";
      url = "https://erp.${secrets.domains.general}/";
    }
    {
      name = "Robin Fileshare";
      url = "https://fileshare.${secrets.domains.general}/";
    }
    {
      name = "SD API";
      url = "https://software-api-admin.${secrets.domains.general}/login";
    }
    {
      name = "vSphere";
      url = "https://photon-machine.${secrets.domains.general}/";
    }
  ];
  typos-config = pkgs.writers.writeTOML "global-typos-config.toml" {
    default = {
      extend-ignore-re = [
        "(?Rm)^.*(#|//)\\s*spellchecker:disable-line$"
      ];
      extend-words = {
        hpe = "hpe"; # spellchecker:disable-line
        ba = "ba"; # spellchecker:disable-line
        hda = "hda"; # spellchecker:disable-line
      };
    };
  };
  commitlint-rs-config = pkgs.writers.writeYAML "global-commitlint-rs-config.yaml" {
    rules.description-format = {
      level = "error";
      format = "^RDDO-[0-9]+";
    };
  };
  pre-commit = (inputs.git-hooks.lib.${pkgs.system}.run {
    src = ./.;
    hooks = rec {
      check-added-large-files.enable = true;
      check-merge-conflicts.enable = true;
      detect-private-keys.enable = true;
      forbid-new-submodules.enable = true;
      end-of-file-fixer.enable = true;
      trim-trailing-whitespace.enable = true;
      ansible-lint.enable = true;
      yamllint.enable = true;
      shellcheck.enable = true;
      typos = {
        enable = true;
        settings.configPath = builtins.toString typos-config;
        args = [
          "--force-exclude"
        ];
      };
      gitleaks = {
        enable = true;
        description = "gitleaks hook";
        package = pkgs.gitleaks;
        entry = "${lib.getExe gitleaks.package} protect --verbose --redact --staged";
      };
      commitlint-rs = {
        enable = true;
        description = "commitlint-rs hook";
        package = (pkgs.writeShellScriptBin "commitlint" /* bash */ ''
          set -euo pipefail

          exec ${lib.getExe pkgs.commitlint-rs} --edit "$( [[ -f .git ]] && cut -f2 -d' ' .git || echo ./.git )/COMMIT_EDITMSG" "$@"
        '');
        entry = lib.getExe commitlint-rs.package;
        args = [
          "--config=${commitlint-rs-config}"
        ];
        stages = [
          "prepare-commit-msg"
        ];
        pass_filenames = false;
        require_serial = true;
      };
    };
  }).config;
in {
  imports =
    let
      hostExtras = (./. + "/${hostname}.nix");
    in builtins.attrValues outputs.homeManagerModules ++ [
      outputs.nixosModules.host
      inputs.impermanence.homeManagerModules.impermanence
      inputs.catppuccin.homeModules.catppuccin
    ] ++ map (m: lib.custom.relativeToHomeManagerModules m) [
      "ansible"
      "alacritty"
      "atuin"
      "bitwarden"
      "btop"
      "development"
      "fonts"
      "ghostty"
      "git"
      "gron"
      "jujutsu"
      "kanata"
      "kubernetes"
      "lazygit"
      "logseq"
      "modern-unix"
      "neovim"
      "nh"
      "nixGL"
      "qrrs"
      "secrets"
      "slack"
      "starship"
      "syncthing"
      "systemctl-tui"
      "tmux"
      "tools"
      "uutils"
      "vim"
      "vscodium"
      "yazi"
      "zen-browser"
      "zsh"
    ] ++ lib.optional (builtins.pathExists hostExtras) hostExtras;

  home = rec {
    username = "lucas.slebos";
    homeDirectory = "/home/${username}";
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  host.work = true;

  home.persistence.home.enable = lib.mkDefault false;

  home.packages = [
    (pkgs.writeShellScriptBin "pre-commit" /* bash */ ''
      set -eou pipefail

      if [ "$#" -eq 0 ]; then
        ${lib.getExe pkgs.pre-commit} --help
      elif [ "$1" == "run" ]; then
        shift
        ${lib.getExe pkgs.pre-commit} run --config ${pre-commit.configFile} "$@"
      else
        ${lib.getExe pkgs.pre-commit} "$@"
      fi
    '')
    (lib.hiPrio (pkgs.bitwarden-cli.overrideAttrs (oldAttrs: rec {
      inherit (oldAttrs) pname;
      version = "2025.5.0";

      src = pkgs.fetchFromGitHub {
        owner = "bitwarden";
        repo = "clients";
        tag = "cli-v${version}";
        hash = "sha256-8jVKwqKhTfhur226SER4sb1i4dY+TjJRYmOY8YtO6CY=";
      };

      npmDeps = pkgs.fetchNpmDeps {
        inherit src;
        name = "${pname}-${version}-npm-deps";
        hash = "sha256-0IoBPRGdtkMeTrT5cqZLHB/WrUCONtsJ6YHh0y4K5Ls=";
      };
    })))
  ];

  programs.alacritty.package = lib.mkForce (config.lib.nixGL.wrap pkgs.unstable.alacritty);

  programs.ghostty.package = lib.mkForce (config.lib.nixGL.wrap pkgs.unstable.ghostty);

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  targets.genericLinux.enable = true;

  programs.firefox.profiles.default.bookmarks.settings = additionalBookmarks;

  programs.zen-browser.profiles.default.bookmarks.settings = additionalBookmarks;

  programs.vscode.profiles.default.userSettings = {
    "files.associations" = {
      "**/pre_tasks/*.yaml" = "ansible";
      "**/pre_tasks/*.yml" = "ansible";
    };
    "typos.config" = typos-config;
  };

  programs.direnv.config = {
    whitelist.prefix = [
      "${config.home.homeDirectory}/code/bitbucket.org/robin-radar-systems"
    ];
  };

  home.file."code/bitbucket.org/robin-radar-systems/robin-deployment-releases/.envrc".text = /* bash */ ''
    source_up_if_exists
    dotenv_if_exists
  '';

  home.file."code/bitbucket.org/robin-radar-systems/robin-deployment-releases/.env".text = /* bash */ ''
    ANSIBLE_VAULT_PASSWORD_FILE=${config.sops.secrets."robin-deployment.txt".path}
  '';

  sops.secrets."robin-deployment.txt".sopsFile = ../lucas.slebos.sops.yaml;

  programs.git = {
    includes =
    let
      robin-radar-systems = pkgs.writeText "robin-radar-systems-git-config" (lib.generators.toGitINI {
        user.email = secrets.email;
        commit.gpgSign = false;
        tag.gpgSign = false;
      });
    in [
      {
        condition = "hasconfig:remote.*.url:git@bitbucket.org:robin-radar-systems/**";
        path = robin-radar-systems;
      }
      {
        condition = "hasconfig:remote.*.url:rrs:**";
        path = robin-radar-systems;
      }
    ];
    extraConfig = {
      url."git@bitbucket.org".insteadof = "bitbucket";
      url."git@bitbucket.org:robin-radar-systems/".insteadof = "rrs:";
    };
    hooks = let
      git-hook = hook: pkgs.writeShellScript hook /* bash */ ''
        set -euo pipefail

        INSTALL_PYTHON=${lib.getExe pkgs.python3}
        ARGS=(hook-impl --config=${pre-commit.configFile} --hook-type=${hook})

        HERE=$(cd "$(dirname "$0")" && pwd)
        ARGS+=(--hook-dir "''${HERE}" -- "$@")

        exec ${lib.getExe pkgs.pre-commit} "''${ARGS[@]}"
      '';
      pre-commit-hooks = hook-types: lib.genAttrs hook-types (hook: git-hook hook);
    in pre-commit-hooks [
      "pre-commit"
      "prepare-commit-msg"
    ];
  };

  xdg.configFile."jj/conf.d/robin-radar-systems.toml".source = (pkgs.formats.toml { }).generate "robin-radar-systems.toml" {
    "--when".repositories = [
      "${config.home.homeDirectory}/code/bitbucket/robin-radar-systems"
    ];
    user.email = secrets.email;
    git.signing-on-push = false;
  };

  sops.secrets."id_ed25519" = {
    sopsFile = ../lucas.slebos.sops.yaml;
    path = ".ssh/id_ed25519";
    mode = "0600";
  };

  home.file.".ssh/id_ed25519.pub".source = ../keys/id_ed25519.pub;

  sops.secrets."id_rsa" = {
    sopsFile = ../lucas.slebos.sops.yaml;
    path = ".ssh/id_rsa";
    mode = "0600";
  };

  home.file.".ssh/id_rsa.pub".source = ../keys/id_rsa.pub;

  systemd.user.tmpfiles.rules = [
    "C ${config.home.homeDirectory}/.ssh/authorized_keys 0600 lucas.slebos lucas.slebos - ${pkgs.writeText "authorized_keys"
      (lib.concatStringsSep "\n" (map (f: builtins.readFile f) [
        ../keys/id_ed25519.pub
        ../keys/id_rsa.pub
      ]))
    }"
  ];

  programs.ssh = with secrets; {
    enable = true;
    matchBlocks = {
      robin-user = {
        host = "*-230 *-231 *-232";
        user = "robin";
        extraOptions = {
          StrictHostKeyChecking = "no";
          UserKnownHostsFile = "/dev/null";
        };
      };
      mps-9999-230 = {
        hostname = "10.200.230.202";
      };
      mps-9999-231 = {
        hostname = "10.200.231.202";
      };
      mps-9999-232 = {
        hostname = "10.200.232.202";
      };
      max-9999-230 = {
        hostname = "10.200.230.207";
      };
      max-9999-231 = {
        hostname = "10.200.231.207";
      };
      max-9999-232 = {
        hostname = "10.200.232.207";
      };
      lts-9999-230 = {
        hostname = "10.200.230.208";
      };
      lts-9999-231 = {
        hostname = "10.200.231.208";
      };
      lts-9999-232 = {
        hostname = "10.200.232.208";
      };
      sts-9999-230 = {
        hostname = "10.200.230.206";
      };
      sts-9999-231 = {
        hostname = "10.200.231.206";
      };
      sts-9999-232 = {
        hostname = "10.200.232.206";
      };
      k700-9999-230 = {
        hostname = "10.200.230.201";
      };
      k700-9999-231 = {
        hostname = "10.200.231.201";
      };
      k700-9999-232 = {
        hostname = "10.200.232.201";
      };
      aptly-user = {
        host = "aptly-ssh.*.${domains.devops}";
        user = "aptly";
      };
    };
  };

  programs.garden-rs.settings = {
    garden.root = "${config.home.homeDirectory}/code";

    trees = {
      apt-mirror = {
        url = "rrs:apt-mirror";
        path = "bitbucket.org/robin-radar-systems/apt-mirror";
      };
      awx-management = {
        url = "rrs:awx-management";
        branch = "main";
        path = "bitbucket.org/robin-radar-systems/awx-management";
      };
      bitwarden-vault = {
        url = "rrs:bitwarden_vault";
        path = "bitbucket.org/robin-radar-systems/bitwarden-vault";
      };
      image-pipeline = {
        url = "rrs:image-pipeline";
        path = "bitbucket.org/robin-radar-systems/image-pipeline";
      };
      kubernetes-cluster-deployment = {
        url = "rrs:kubernetes-cluster-deployment";
        path = "bitbucket.org/robin-radar-systems/kubernetes-cluster-deployment";
      };
      kubernetes-deployments = {
        url = "rrs:kubernetes-deployments";
        path = "bitbucket.org/robin-radar-systems/kubernetes-deployments";
      };
      network-install = {
        url = "rrs:network-install";
        path = "bitbucket.org/robin-radar-systems/network-install";
      };
      nix-config = {
        url = "github:daluca/nix-config";
        path = "github.com/daluca/nix-config";
      };
      nixvim-config = {
        url = "github:daluca/nixvim-config";
        path = "github.com/daluca/nixvim-config";
      };
      pipelines-devops = {
        url = "rrs:pipelines-devops";
        path = "bitbucket.org/robin-radar-systems/pipelines-devops";
      };
      robin-deployment = {
        url = "rrs:robin-deployment";
        path = "bitbucket.org/robin-radar-systems/robin-deployment";
        branch = "main";
      };
      "robin-deployment/release-candidate-1.5-dev" = {
        worktree = "robin-deployment";
        branch = "release/release-candidate-1.5-dev";
        path = "bitbucket.org/robin-radar-systems/robin-deployment-releases/release-candidate-1.5-dev";
      };
      "robin-deployment/release-candidate-1.6-dev" = {
        worktree = "robin-deployment";
        branch = "release/release-candidate-1.6-dev";
        path = "bitbucket.org/robin-radar-systems/robin-deployment-releases/release-candidate-1.6-dev";
      };
      "robin-deployment/release-candidate-1.7-dev" = {
        worktree = "robin-deployment";
        branch = "release/release-candidate-1.7-dev";
        path = "bitbucket.org/robin-radar-systems/robin-deployment-releases/release-candidate-1.7-dev";
      };
      "robin-deployment/release-candidate-1.8" = {
        worktree = "robin-deployment";
        branch = "release/release-candidate-1.8";
        path = "bitbucket.org/robin-radar-systems/robin-deployment-releases/release-candidate-1.8";
      };
      "robin-deployment/release-candidate-1.9" = {
        worktree = "robin-deployment";
        branch = "release/release-candidate-1.9";
        path = "bitbucket.org/robin-radar-systems/robin-deployment-releases/release-candidate-1.9";
      };
      robin-scripts = {
        url = "rrs:robin-scripts";
        path = "bitbucket.org/robin-radar-systems/robin-scripts";
      };
      robin-software-modules = {
        url = "rrs:robin-software-modules";
        path = "bitbucket.org/robin-radar-systems/robin-software-modules";
      };
    };

    groups = {
      devops = [
        "apt-mirror"
        "awx-management"
        "bitwarden-vault"
        "image-pipeline"
        "kubernetes-cluster-deployment"
        "kubernetes-deployments"
        "network-install"
        "pipelines-devops"
        "robin-deployment"
        "robin-deployment/release-candidate-1.5-dev"
        "robin-deployment/release-candidate-1.6-dev"
        "robin-deployment/release-candidate-1.7-dev"
        "robin-deployment/release-candidate-1.8"
        "robin-deployment/release-candidate-1.9"
        "robin-scripts"
        "robin-software-modules"
      ];
      personal = [
        "nix-config"
        "nixvim-config"
      ];
    };

    gardens = {
      personal.groups = [
        "personal"
      ];
      robin-radar-systems.groups = [
        "devops"
      ];
      all.groups = [
        "devops"
        "personal"
      ];
    };

    commands = {
      git = "git \"$@\"";
      pull = "git pull \"$@\"";
      status = "git status --short \"$@\"";
    };
  };

  sops.secrets."dev.kubeconfig" = {
    sopsFile = ../lucas.slebos.sops.yaml;
    path = ".kube/dev.kubeconfig";
  };

  sops.secrets."stg.kubeconfig" = {
    sopsFile = ../lucas.slebos.sops.yaml;
    path = ".kube/stg.kubeconfig";
  };

  sops.secrets."prod.kubeconfig" = {
    sopsFile = ../lucas.slebos.sops.yaml;
    path = ".kube/prod.kubeconfig";
  };

  services.syncthing.settings = {
    folders = {
      "${config.home.homeDirectory}/Documents" = {
        label = "Documents";
        id = "documents";
      };
    };
  };

  programs.bash.enable = true;

  xdg.enable = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
