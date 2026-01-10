{ pkgs, ... }:

{
  programs.vscode.profiles.default = {
    extensions = with pkgs.open-vsx; [
      wayou.vscode-todo-highlight
    ];
  };
}
