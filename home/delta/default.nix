{
  programs.delta = {
    enable = true;
    options = {
      line-numbers = true;
    };
  };

  programs.git.settings.alias.diff-side-by-side = "-c delta.features=side-by-side diff";

  catppuccin.delta.enable = true;
}
