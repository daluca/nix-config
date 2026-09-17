{
  flake.homeManagerModules.feishin = { pkgs, ... }: {
    home.packages = with pkgs; [
      feishin
    ];

    home.persistence.home.directories = [
      ".config/feishin"
    ];
  };
}
