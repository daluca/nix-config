{ pkgs, ...}:

{
  programs.vscode.profiles.default = {
    extensions = with pkgs.open-vsx; [
      jnoortheen.nix-ide
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
      "nix.hiddenLanguageServerErrors" = [
        "textDocument/definition"
        "textDocument/documentSymbol"
      ];
      "files.associations" = {
        "flake.lock" = "json";
      };
    };
  };
}
