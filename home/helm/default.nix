{ config, pkgs, ... }:

{
  imports = [ ./vscode.nix ];

  home.packages = with pkgs.unstable; [ kubernetes-helm ];
}
