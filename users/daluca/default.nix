{ config, ... }:

{
  users.users.daluca = {
    isNormalUser = true;
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

  home-manager.users.daluca = import ./home;
}
