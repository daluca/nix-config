{
  imports = [
    ./bravo.nix
  ];

  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;
}
