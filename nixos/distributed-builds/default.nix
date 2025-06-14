{
  imports = [
    ./darnassus.nix
  ];

  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;
}
