{ lib, osConfig, ... }:

{
  imports = [
    ./nixvim.nix
  ];

  home.shellAliases = {
    n = "nvim";
  };

  home.persistence.home.directories = lib.mkIf osConfig.environment.persistence.system.enable [
    ".local/share/nvim"
  ];
}
