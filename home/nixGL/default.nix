{ config, lib, pkgs, ... }:

{
  targets.genericLinux.nixGL = {
    packages = pkgs.nixgl;
    defaultWrapper = lib.mkDefault "mesa";
    installScripts = lib.mkDefault [ "mesa" ];
  };

  nixpkgs.overlays = with config.lib; [
    (_final: prev: {
      alacritty = nixGL.wrap prev.alacritty;
      ghostty = nixGL.wrap prev.ghostty;
      neovide = nixGL.wrap prev.neovide;
    })
  ];
}
