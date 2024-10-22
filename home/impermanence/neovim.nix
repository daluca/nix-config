{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (config.programs) nixvim;
in {
  home.persistence.home.directories = mkIf nixvim.enable
    [ ".local/share/nvim" ];
}
