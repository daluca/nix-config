{ pkgs, ... }:

{
  programs.vscode = {
    extensions = with pkgs.open-vsx; [
      skellock.just
    ];
    userSettings = {
      "files.associations" = {
        "**.just" = "just";
      };
    };
  };
}
