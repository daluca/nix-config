{
  flake.homeModules.logseq = { pkgs, ... }: {
    home.packages = with pkgs; [
      logseq
    ];
  };
}
