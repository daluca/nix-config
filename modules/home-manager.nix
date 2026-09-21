{ inputs, ... }:

{
  flake.nixosModules.home-manager = { secrets, ... }: {
    imports = with inputs; [
      home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs secrets; };
    };
  };
}
