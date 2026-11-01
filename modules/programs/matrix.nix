{
  flake.homeModules.element = { pkgs, ... }: {
    home.packages = with pkgs; [
      element-desktop
    ];

    home.persistence.home.directories = [
      ".config/Element"
    ];
  };
}
