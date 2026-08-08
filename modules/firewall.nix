{ self, ... }:

{
  flake.nixosModules.firewall = {
    networking = {
      firewall.enable = true;
      nftables.enable = true;
    };
  };
}
