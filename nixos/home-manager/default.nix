{ system, secrets, inputs, outputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit system inputs outputs secrets; };
    users.daluca = import ../../home;
  };
}
