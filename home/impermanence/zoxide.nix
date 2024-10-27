{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (config.programs) zoxide;
in {
  home.persistence.home.directories = mkIf zoxide.enable [
    ".local/share/zoxide"
  ];
}
