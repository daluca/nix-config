{ pkgs, ... }:

{
  programs.vscode.profiles.default = {
    extensions = with pkgs.open-vsx; [
      helm-ls.helm-ls
    ] ++ [
      ms-kubernetes-tools.vscode-kubernetes-tools
    ] ++ [
      redhat.vscode-yaml
    ];
    userSettings = {
      "helm-ls.path" = "${pkgs.helm-ls}/bin/helm-ls";
    };
  };
}
