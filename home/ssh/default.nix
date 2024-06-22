{ config, ... }:

{
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      gainas.hostname = "10.2.161.172";
      raspberry-nix.hostname = "10.2.74.60";
    };
  };
}
