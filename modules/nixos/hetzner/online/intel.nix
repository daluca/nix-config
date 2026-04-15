{ inputs, outputs, ... }:

{
  imports = with inputs; with outputs.nixosModules; [
    hetzner-online

    srvos.nixosModules.hardware-hetzner-online-intel
  ];
}
