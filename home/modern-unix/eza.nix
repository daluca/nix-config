{
  programs.eza = {
    enable = true;
    enableBashIntegration = false;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group"
      "--binary"
    ];
  };

  catppuccin.eza.enable = true;
}
