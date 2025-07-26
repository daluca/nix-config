{ config, lib, inputs, ... }:

{
  nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = lib.mkDefault "mesa";
    installScripts = lib.mkDefault [ "mesa" ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      alacritty = config.lib.nixGL.wrap prev.alacritty;
      ghostty = config.lib.nixGL.wrap prev.ghostty;
    })
  ];
}
