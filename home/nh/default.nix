{ config, pkgs, ... }:

{
  programs.nh = {
    enable = true;
    package = pkgs.unstable.nh;
    flake = "${config.home.homeDirectory}/code/github.com/daluca/nix-config";
  };
}
