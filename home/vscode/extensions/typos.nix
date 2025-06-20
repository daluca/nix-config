{ pkgs, ... }:

{
  programs.vscode.profiles.default = {
    extensions = with pkgs.open-vsx; [
      tekumara.typos-vscode
    ];
    userSettings = {
      "typos.path" = "${pkgs.typos-lsp}/bin/typos-lsp";
    };
  };
}
