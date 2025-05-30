{ pkgs, ... }:

{
  imports = [
    ./garden.nix
    ./direnv.nix
    ./just.nix
    ./jujutsu.nix
  ];

  home.packages = with pkgs.unstable; [
    kondo
  ];

  home.persistence.home.directories = [
    "code"
  ];
}
