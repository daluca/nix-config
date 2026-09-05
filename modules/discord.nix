{
  flake.homeManagerModules.discord = { pkgs, ... }: {
    home.packages = with pkgs; [
      discord
    ];

    home.persistence.home.directories = [
      ".config/discord"
    ];
  };
}
