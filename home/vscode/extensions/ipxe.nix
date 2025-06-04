{ pkgs, ... }:

{
  programs.vscode.profiles.default = {
    extensions = with pkgs.open-vsx; [
      kipjr.vscode-language-ipxe
    ];
  };
}
