{
  flake.homeModules.gron = { pkgs, ... }: {
    home.packages = with pkgs; [
      unstable.gron
    ];

    home.shellAliases = {
      ungron = "gron --ungron";
    };
  };
}
