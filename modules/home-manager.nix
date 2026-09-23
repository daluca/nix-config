{ inputs, ... }:

{
  imports = with inputs; [
    home-manager.flakeModules.home-manager
  ];

  flake.nixosModules.home-manager = {
    imports = with inputs; [
      home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
