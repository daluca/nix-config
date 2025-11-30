{ lib, ... }:

{
  specialisation.gaming.configuration = {
    services.xserver.xkb.variant = lib.mkForce ",dvorak";
  };
}
