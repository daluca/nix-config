{ inputs, ... }:

{
  flake.nixosModules.plymouth = {
    imports = with inputs.self.nixosModules; [
      catppuccin
    ];

    boot.plymouth.enable = true;

    boot.kernelParams = [
      "quiet"
    ];

    catppuccin.plymouth.enable = true;
  };
}
