{ inputs, ... }:

{
  imports = [
    inputs.srvos.nixosModules.hardware-hetzner-cloud-arm

    ./..
  ];
}
