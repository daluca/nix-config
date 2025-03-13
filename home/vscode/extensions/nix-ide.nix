{ pkgs, ...}:
let
  inherit (pkgs) nixd;
  inherit (pkgs.open-vsx.jnoortheen) nix-ide;
in {
  programs.vscode = {
    extensions = [
      nix-ide
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${nixd}/bin/nixd";
      "files.associations" = {
        "flake.lock" = "json";
      };
    };
  };
}
