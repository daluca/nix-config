{ pkgs, ... }:
let
  inherit (pkgs.open-vsx.tonybaloney) vscode-pets;
in {
  programs.vscode.profiles.default = {
    extensions = [
      vscode-pets
    ];
    userSettings = {
      "vscode-pets.position" = "explorer";
    };
  };
}
