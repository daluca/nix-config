{ self, ... }:

{
  flake.nixosModules.daluca =
    {
      config,
      lib,
      secrets,
      ...
    }:
    {
      home-manager.users.daluca = {
        imports = with self.homeModules; [
          daluca
        ];

        _module.args.secrets = secrets // fromTOML (builtins.readFile ./secrets.toml);
      };

      users.users.daluca = {
        isNormalUser = true;
        description = "Lucas Slebos";
        hashedPasswordFile = config.sops.secrets."daluca/password".path;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keyFiles = [
          ./keys/id_ed25519.pub
        ];
      };

      virtualisation.vmVariant = {
        users.users.daluca = {
          initialPassword = "hello";
          hashedPasswordFile = lib.mkVMOverride null;
        };

        home-manager.users.daluca = {
          programs.atuin.settings.key_path = lib.mkVMOverride "${config.home-manager.users.daluca.xdg.configHome}/atuin/key";
        };
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
    };

  flake.homeModules.daluca = {
    home = rec {
      username = "daluca";
      homeDirectory = "/home/${username}";
    };
  };
}
