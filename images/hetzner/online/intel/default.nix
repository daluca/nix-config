{ inputs, ... }:

{
  imports = with inputs; [
    ./..

    srvos.nixosModules.hardware-hetzner-online-intel
  ];
}
