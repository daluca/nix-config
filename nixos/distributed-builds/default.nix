{
  imports = [
    ./bravo.nix
    ./dalaran.nix
  ];

  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;
}
