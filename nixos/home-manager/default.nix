{ system, secrets, inputs, outputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = false;
    extraSpecialArgs = { inherit inputs outputs system secrets; };
    users.daluca = import ../../home;
  };
}
