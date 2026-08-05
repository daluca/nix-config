{ pkgs, ... }:

{
  documentation.nixos.enable = false;

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];
}
