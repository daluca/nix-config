{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum;
in {
  options.themes.catppuccin = {
    flavour = mkOption {
      type = enum [
        "Latte"
        "Frappe"
        "Macchiato"
        "Mocha"
      ];
      default = "Mocha";
      description = ''
        Catppuccin flavour.
      '';
    };
  };
}
