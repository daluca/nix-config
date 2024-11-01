{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (config.programs) thunderbird;
in {
  home.persistence.home.directories = mkIf thunderbird.enable [
    ".thunderbird"
  ];
}
