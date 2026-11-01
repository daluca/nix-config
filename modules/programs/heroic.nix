{
  flake.homeModules.heroic = { pkgs, ... }: {
    programs.heroic = {
      enable = true;
      package = pkgs.unstable.heroic;
    };

    home.persistence.home.directories = [
      ".config/heroic"
      ".local/share/Heroic"
    ];
  };
}
