{ pkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./garden-rs.nix
    ./just.nix
  ];

  home.packages = with pkgs.unstable; [
    kondo
  ];

  home.persistence.home.directories = [
    "code"
  ];
}
