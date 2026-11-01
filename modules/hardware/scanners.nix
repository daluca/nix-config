{
  flake.nixosModules.scanners = {
    hardware.sane = {
      enable = true;
    };

    users.users.daluca.extraGroups = [
      "scanner"
    ];
  };
}
