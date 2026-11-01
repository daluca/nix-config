{
  flake.homeModules.gradia = { pkgs, ... }: {
    home.packages = with pkgs; [
      gradia
    ];
  };
}
