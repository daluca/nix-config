{ config, lib, pkgs, hostname, inputs, outputs, ... }@args:
let
  secrets = args.secrets // builtins.fromTOML (builtins.readFile ../secrets.toml);
in {
  imports =
    let
      hostExtras = (./. + "/${hostname}.nix");
    in builtins.attrValues outputs.homeManagerModules ++ [
      inputs.impermanence.homeManagerModules.default
      inputs.catppuccin.homeModules.default
    ] ++ map (m: lib.custom.relativeToHomeManagerModules m) [
      "ansible"
      "alacritty"
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

  programs.bash.enable = true;

  xdg.enable = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
