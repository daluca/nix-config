{
  flake.homeManagerModules.signal = { pkgs, ... }: {
    home.packages = with pkgs; [
      signal-desktop
    ];

    home.persistence.home.directories = [
      ".config/Signal"
    ];
  };
}
