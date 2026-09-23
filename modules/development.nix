{ self, ... }:

{
  flake.homeModules.development = { pkgs, ... }: {
    imports = with self.homeModules; [
      direnv
      garden-tools
      just
      opentofu
    ];

    programs.gpg.publicKeys = [
      {
        source = pkgs.fetchurl {
          url = "https://github.com/web-flow.gpg";
          hash = "sha256-bor2h/YM8/QDFRyPsbJuleb55CTKYMyPN4e9RGaj74Q=";
        };
        trust = "full";
      }
    ];

    home.persistence.home.directories = [
      "Projects"
    ];
  };
}
