{ config, lib, pkgs, ... }:

{
  programs.vscode = lib.mkIf config.programs.vscode.enable {
    extensions = with pkgs.unstable.vscode-extensions; [
      ms-kubernetes-tools.vscode-kubernetes-tools
      redhat.vscode-yaml
    ];
    userSettings = {
      "redhat.telemetry.enabled" = false;
    };
  };
}
