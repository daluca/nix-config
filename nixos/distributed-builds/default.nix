{
  imports = [
    ./alfa.nix
    ./bravo.nix
    ./dalaran.nix
  ];

  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;
}
