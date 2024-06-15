{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.vscode = lib.mkIf config.programs.vscode.enable {
    extensions = with pkgs.unstable.vscode-extensions; [ hashicorp.terraform ];
  };
}
