{ pkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./garden-tools.nix
    ./just.nix
  ];

  home.packages = with pkgs.unstable; [
    kondo
  ];

  home.persistence.home.directories = [
    "code"
  ];
}
