{
  flake.homeManagerModules.bitwarden = { pkgs, ... }: {
    home.packages = with pkgs; [
      bitwarden-desktop
      bitwarden-cli
    ];

    home.persistence.home.directories = [
      ".config/Bitwarden"
    ];
  };
}
