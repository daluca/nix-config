{ config, lib, pkgs, ... }:

{
  networking.firewall = rec {
    allowedTCPPortRanges = lib.mkIf (builtins.elem pkgs.gnomeExtensions.gsconnect config.home-manager.users.daluca.home.packages) [
      { from = 1714; to = 1764; }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}
