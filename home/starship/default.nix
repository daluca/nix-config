{
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    settings = {
      direnv.disabled = false;
      kubernetes.disabled = false;
    };
  };

  catppuccin.starship.enable = true;
}
