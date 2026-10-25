{
  flake.homeModules.intiface-central = { pkgs, ... }: {
    home.packages = with pkgs; [
      unstable.intiface-central
    ];

    home.persistence.home.directories = [
      ".local/share/com.nonpolynomial.intiface_central"
    ];
  };
}
