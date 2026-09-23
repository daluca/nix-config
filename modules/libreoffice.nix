{
  flake.homeModules.libreoffice = { pkgs, ... }: {
    home.packages = with pkgs; [
      libreoffice
    ];
  };
}
