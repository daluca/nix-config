{ config, lib, pkgs, ... }:

{
  programs.vscode.profiles.default = {
    extensions = with pkgs.open-vsx; [
      jjk.jjk
    ];
    userSettings = {
      "git.enabled" = lib.mkForce false;
      "jjk.jjPath" = lib.getExe config.programs.jujutsu.package;
    };
  };
}
