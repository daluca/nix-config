{
  flake.homeManagerModules.logseq = { pkgs, ... }: {
    home.packages = with pkgs; [
      logseq
    ];
  };
}
