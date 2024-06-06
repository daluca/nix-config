{ config, ... }:

{
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "daily";
    };
  };

  users.users.daluca.extraGroups = [ "docker" ];
}
