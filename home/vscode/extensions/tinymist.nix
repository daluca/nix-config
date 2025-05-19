{ pkgs, ... }:

{
  programs.vscode.profiles.default = {
    extensions = with pkgs.open-vsx; [
      myriad-dreamin.tinymist
    ];
    userSettings = {
      "tinymist.serverPath" = "${pkgs.unstable.tinymist}/bin/tinymist";
      "tinymist.exportPdf" = "onType";
    };
  };
}
