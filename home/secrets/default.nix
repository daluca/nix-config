{ lib, osConfig, ... }:

{
  home.persistence.home.directories = lib.mkIf osConfig.environment.persistence.system.enable [
    ".config/sops/age"
  ];
}
