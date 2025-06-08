{ pkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./garden-rs.nix
    ./jujutsu.nix
    ./just.nix
  ];

  home.packages = with pkgs.unstable; [
    kondo
  ];

  home.persistence.home.directories = [
    "code"
  ];
}
