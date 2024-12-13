{ config, ... }:
let
  inherit (config.programs) lazygit;
in {
  programs.lazygit = {
    enable = true;
  };

  programs.git.aliases = {
    lazy = "!${lazygit.package}/bin/lazygit";
  };
}
