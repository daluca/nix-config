{
  flake.homeManagerModules.gradia = { pkgs, ... }: {
    home.packages = with pkgs; [
      gradia
    ];
  };
}
