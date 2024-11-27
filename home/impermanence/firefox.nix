{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (config.programs) firefox;
in {
  home.persistence.home.directories = mkIf firefox.enable [
    ".mozilla"
  ];
}
