{ config, lib, pkgs, hostname, inputs, outputs, ... }@args:
let
  secrets = args.secrets // builtins.fromTOML (builtins.readFile ../secrets.toml);
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
      "kanata"
      "kubernetes"
      "lazygit"
      "logseq"
      "modern-unix"
      "neovim"
      "nh"
      "qrrs"
      "secrets"
      "slack"
      "starship"
      "tmux"
      "tools"
      "uutils"
      "vim"
      "vscodium"
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

  home.persistence.home.enable = lib.mkDefault false;

  home.packages = with pkgs; [
    nixgl.nixGLIntel
  ];

  programs.alacritty.package = lib.mkForce (pkgs.unstable.alacritty.overrideAttrs (_: {
    postFixup = /* bash */ ''
      ${pkgs.gnused}/bin/sed -i "s|^Exec=alacritty|Exec=nixGLIntel alacritty|" $out/share/applications/Alacritty.desktop
      chmod 0444 $out/share/applications/Alacritty.desktop
    '';
  }));

  programs.ghostty.package = lib.mkForce (pkgs.unstable.ghostty.overrideAttrs (oldAttrs: {
    postFixup = oldAttrs.postFixup + /* bash */ ''
      substituteInPlace $out/share/applications/com.mitchellh.ghostty.desktop \
        --replace Exec=ghostty "Exec=nixGLIntel ghostty"
    '';
  }));

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  targets.genericLinux.enable = true;

  programs.vscode.profiles.default.userSettings = {
    "files.associations" = {
      "**/pre_tasks/*.yaml" = "ansible";
      "**/pre_tasks/*.yml" = "ansible";
    };
  };

  programs.git = {
    includes = [
      {
        condition = "hasconfig:remote.*.url:git@bitbucket.org:robin-radar-systems/**";
        path = "robin-radar-systems";
      }
      {
        condition = "hasconfig:remote.*.url:rrs:**";
        path = "robin-radar-systems";
      }
    ];
    extraConfig = {
      url."git@bitbucket.org".insteadof = "bitbucket";
      url."git@bitbucket.org:robin-radar-systems/".insteadof = "rrs:";
    };
  };

  xdg.configFile."git/robin-radar-systems".text = lib.generators.toGitINI {
    user.email = secrets.email;
    commit.gpgSign = false;
    tag.gpgSign = false;
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

  home.file.".ssh/authorized_keys".text = lib.concatStringsSep "\n" (map (f: builtins.readFile f) [
    ../keys/id_ed25519.pub
    ../keys/id_rsa.pub
  ]);

  programs.ssh = with secrets; {
    enable = true;
    matchBlocks = {
      awx = {
        user = "awx";
        hostname = "awx.${domains.general}";
      };
      robin-user = {
        host = "*-8888 *-9999 *-awx *-68 *-test *-230";
        user = "robin";
        extraOptions = {
          StrictHostKeyChecking = "no";
          UserKnownHostsFile = "/dev/null";
        };
      };
      "*-awx" = {
        proxyJump = "awx";
      };
      iris-8888 = {
        hostname = "10.200.100.107";
      };
      iris-9999 = {
        hostname = "10.200.100.93";
      };
      iris-9999-awx = {
        hostname = "192.168.50.112";
      };
      iris-9999-68 = {
        hostname = "10.200.68.25";
      };
      max-8888 = {
        hostname = "10.200.100.96";
      };
      sts-8888 = {
        hostname = "10.200.100.94";
      };
      lts-8888 = {
        hostname = "10.200.100.95";
      };
      max-9999 = {
        hostname = "10.200.100.104";
      };
      sts-9999 = {
        hostname = "10.200.100.105";
      };
      lts-9999 = {
        hostname = "10.200.100.106";
      };
      k700-test = {
        hostname = "10.200.230.201";
      };
      "aptly-ssh.dev.${domains.devops}" = {
        user = "aptly";
      };
      "aptly-ssh.prod.${domains.devops}" = {
        user = "aptly";
      };
      mps-9999-230 = {
        hostname = "10.200.230.202";
      };
    };
  };

  programs.garden-rs.settings = {
    garden.root = "${config.home.homeDirectory}/code";

    trees = {
      awx = {
        url = "rrs:awx";
        branch = "main";
        path = "bitbucket/robin-radar-systems/awx";
      };
      "awx/release-candidate-1.6-dev" = {
        worktree = "awx";
        branch = "release/release-candidate-1.6-dev";
        path = "bitbucket/robin-radar-systems/awx-releases/release-candidate-1.6-dev";
      };
      "awx/release-candidate-1.7-dev" = {
        worktree = "awx";
        branch = "release/release-candidate-1.7-dev";
        path = "bitbucket/robin-radar-systems/awx-releases/release-candidate-1.7-dev";
      };
      apt-mirror = {
        url = "rrs:apt-mirror";
        path = "bitbucket/robin-radar-systems/apt-mirror";
      };
      kubernetes-cluster-deployment = {
        url = "rrs:kubernetes-cluster-deployment";
        path = "bitbucket/robin-radar-systems/kubernetes-cluster-deployment";
      };
      kubernetes-deployments = {
        url = "rrs:kubernetes-deployments";
        path = "bitbucket/robin-radar-systems/kubernetes-deployments";
      };
      network-install = {
        url = "rrs:network-install";
        path = "bitbucket/robin-radar-systems/network-install";
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
        path = "bitbucket/robin-radar-systems/pipelines-devops";
      };
      robin-deployment = {
        url = "rrs:robin-deployment";
        path = "bitbucket/robin-radar-systems/robin-deployment";
        branch = "main";
      };
      "robin-deployment/release-candidate-1.6-dev" = {
        worktree = "robin-deployment";
        branch = "release/release-candidate-1.6-dev";
        path = "bitbucket/robin-radar-systems/robin-deployment-releases/release-candidate-1.6-dev";
      };
      "robin-deployment/release-candidate-1.7-dev" = {
        worktree = "robin-deployment";
        branch = "release/release-candidate-1.7-dev";
        path = "bitbucket/robin-radar-systems/robin-deployment-releases/release-candidate-1.7-dev";
      };
      robin-scripts = {
        url = "rrs:robin-scripts";
        path = "bitbucket/robin-radar-systems/robin-scripts";
      };
    };

    groups = {
      devops = [
        "awx"
        "awx/release-candidate-1.6-dev"
        "awx/release-candidate-1.7-dev"
        "apt-mirror"
        "kubernetes-cluster-deployment"
        "kubernetes-deployments"
        "network-install"
        "pipelines-devops"
        "robin-deployment"
        "robin-deployment/release-candidate-1.6-dev"
        "robin-deployment/release-candidate-1.7-dev"
        "robin-scripts"
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

  sops.secrets."prod.kubeconfig" = {
    sopsFile = ../lucas.slebos.sops.yaml;
    path = ".kube/prod.kubeconfig";
  };

  home.sessionVariables = {
    KUBECONFIG = "${config.home.homeDirectory}/.kube/dev.kubeconfig:${config.home.homeDirectory}/.kube/prod.kubeconfig";
  };

  programs.bash.enable = true;

  xdg.enable = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
