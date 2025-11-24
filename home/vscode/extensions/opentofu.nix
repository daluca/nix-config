{ lib, pkgs, ... }:

{
  programs.vscode.profiles.default = {
    extensions = with pkgs.open-vsx; [
      opentofu.vscode-opentofu
    ];
    userSettings = {
      "opentofu.languageServer.path" = lib.getExe pkgs.unstable.tofu-ls;
    };
  };
}
