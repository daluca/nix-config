{ config, lib, inputs, ... }:

{
  nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = lib.mkDefault "nvidia";
    installScripts = lib.mkDefault [ "nvidia" ];
  };

  nixpkgs.overlays = with config.lib; [
    (_final: prev: {
      alacritty = nixGL.wrap prev.alacritty;
      ghostty = nixGL.wrap prev.ghostty;
      neovide = nixGL.wrap prev.neovide;
    })
  ];
}
