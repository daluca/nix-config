{ inputs, outputs, ... }:

{
  imports = with inputs; with outputs.nixosModules; [
    hetzner-cloud

    srvos.nixosModules.hardware-hetzner-cloud
  ];
}
