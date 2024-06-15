{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; lib.mkIf config.programs.vscode.enable [ ansible-lint ];

  programs.vscode = lib.mkIf config.programs.vscode.enable {
    extensions = with pkgs.unstable.vscode-extensions; [
      ms-python.python
      redhat.vscode-yaml
      redhat.ansible
    ];
    userSettings = {
      "redhat.telemetry.enabled" = false;
    };
  };
}
