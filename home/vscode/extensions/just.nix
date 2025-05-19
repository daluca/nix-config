{ pkgs, ... }:

{
  programs.vscode.profiles.default = {
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
