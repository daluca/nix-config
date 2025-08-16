{ config, ... }@args:
let
  inherit (config.home-manager.users.daluca.home) username;
  secrets = config.sops.secrets // args.secrets // builtins.fromTOML (builtins.readFile ./secrets.toml);
in {
  users.users.daluca = {
    isNormalUser = true;
    description = "Lucas Slebos";
    hashedPasswordFile = secrets."daluca/password".path;
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
      name = username;
      password = secrets.adguardhome.password;
    }
  ];

  services.openssh.settings.AllowUsers = [
    username
  ];

  home-manager.users.daluca = import ./home;
}
