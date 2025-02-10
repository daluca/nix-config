{ config, ... }:
let
  inherit (config.programs) lazygit;
in {
  programs.lazygit = {
    enable = true;
    settings = {
      disableStartupPopups = true;
      confirmOnQuit = true;
    };
  };

  programs.git.aliases = {
    lazy = "!${lazygit.package}/bin/lazygit";
  };
}
