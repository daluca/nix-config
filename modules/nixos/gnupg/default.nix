{ config, pkgs, ... }:

{
  programs.gnupg.agent.enable = true;

  hardware.gpgSmartcards.enable = true;
}
