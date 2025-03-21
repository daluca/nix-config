{ config, ... }:
let
  inherit (config.sops) secrets;
  inherit (config.home-manager.users.daluca.home) username;
in {
  users.users.daluca = {
    isNormalUser = true;
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

  services.openssh.settings.AllowUsers = [
    username
  ];

  home-manager.users.daluca = import ./home;
}
