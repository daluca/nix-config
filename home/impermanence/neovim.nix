{ config, lib, system, inputs, ... }:
let
  inherit (lib) mkIf;
  inherit (inputs.nixvim-config.packages.${system}) neovim;
in {
  home.persistence.home.directories = mkIf (builtins.elem neovim config.home.packages) [
    ".local/share/nvim"
  ];
}
