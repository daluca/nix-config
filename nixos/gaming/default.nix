{ lib, ... }:
let
  inherit (lib) mkForce;
in {
  specialisation.gaming.configuration = {
    services.xserver.xkb.variant = mkForce ",dvorak";
  };
}
