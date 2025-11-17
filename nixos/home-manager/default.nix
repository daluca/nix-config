{ secrets, inputs, outputs, ... }:

{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs secrets; };
  };
}
