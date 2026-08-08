{ self, ... }:
let
  secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
in
{
  flake.nixosModules.users-daluca = { config, ... }: {
    users.users.daluca = {
      isNormalUser = true;
      description = "Lucas Slebos";
      hashedPasswordFile = config.sops.secrets."daluca/password".path;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keyFiles = [
        ./keys/id_ed25519.pub
      ];
    };

    sops.secrets."daluca/password" = {
      neededForUsers = true;
      sopsFile = ./daluca.sops.yaml;
      key = "password";
    };

    services.adguardhome.settings.users = [
      {
        name = "daluca";
        password = secrets.adguardhome.password;
      }
    ];

    services.openssh.settings.AllowUsers = [
      "daluca"
    ];

    # TODO: Update with daluca home-manager module
    # home-manager.users.daluca = import ../../users/daluca/home;
    home-manager.users.daluca.imports = with self.homeManagerModules; [
      users-daluca
    ];
  };

  flake.homeManagerModules.users-daluca = { config, lib, ... }: {
    imports = with self.homeManagerModules; [
      self.nixosModules.host

      catppuccin
      garden-tools
      kanata
      ntfyd

      ../../../home/openssh
      ../../../home/secrets
      ../../../home/starship
      ../../../home/tmux
      ../../../home/tools
      ../../../home/zsh
      atuin
      bash
      btop
      ntfy
      vim
    ];

    home = rec {
      username = "daluca";
      homeDirectory = "/home/${username}";
    };

    home.persistence.home = {
      enable = lib.mkDefault false;
      persistentStoragePath = "/persistent/";
    };

    nix.extraOptions = ''
      !include ${config.sops.templates."github-access-token.conf".path}
    '';

    sops.templates."github-access-token.conf".content = ''
      access-tokens = github.com=${config.sops.placeholder."github/access-token"}
    '';

    sops.secrets."github/access-token" = { };

    xdg.enable = true;

    xdg.terminal-exec = {
      enable = true;
      settings.default = [
        "com.mitchellh.ghostty.desktop"
      ];
    };

    home.shellAliases = {
      open = "xdg-open";
    };

    home.preferXdgDirectories = true;

    home.stateVersion = "26.05";

    programs.home-manager.enable = true;
  };
}
