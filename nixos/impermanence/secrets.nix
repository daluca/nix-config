{ lib, ... }:

{
  sops.age.keyFile = lib.mkForce "/persistent/system/var/lib/sops-nix/keys.txt";
}
