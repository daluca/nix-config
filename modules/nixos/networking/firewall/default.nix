{ config, ... }:

{
  imports = [ ./kdeconnect.nix ];

  networking.firewall.enable = true;
}
