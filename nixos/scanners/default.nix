{
  hardware.sane = {
    enable = true;
    # drivers.scanSnap.enable = true;
  };

  users.users.daluca.extraGroups = [
    "scanner"
  ];
}
