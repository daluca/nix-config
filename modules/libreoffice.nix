{
  flake.homeManagerModules.libreoffice = { pkgs, ... }: {
    home.packages = with pkgs; [
      libreoffice
    ];
  };
}
