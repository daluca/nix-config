{
  imports = [
    ./darnassus.nix
    ./azeroth.nix
  ];

  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;
}
