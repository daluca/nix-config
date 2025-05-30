{ pkgs, ... }:

{
  programs.vscode.profiles.default = {
    extensions = with pkgs.open-vsx; [
      mads-hartmann.bash-ide-vscode
    ];
    userSettings = {
      "bashIde.shellcheckPath" = "${pkgs.shellcheck}/bin/shellcheck";
      "bashIde.shfmt.path" = "${pkgs.shfmt}/bin/shfmt";
    };
  };
}
