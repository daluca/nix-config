{ inputs, ... }:

{
  flake.homeManagerModules.nix-utils = { pkgs, ... }: {
    imports =
      with inputs;
      with inputs.self.homeManagerModules;
      [
        nh
        comma
      ];

    home.packages = with pkgs; [
      nix-inspect
    ];
  };
}
