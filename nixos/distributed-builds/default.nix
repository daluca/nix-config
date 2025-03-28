{
  imports = [
    ./darnassus.nix
    ./guiltyspark.nix
  ];

  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;
}
