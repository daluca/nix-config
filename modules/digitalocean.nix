{ self, ... }:

{
  flake.nixosModules.digitalocean = { modulesPath, ... }: {
    imports = with self.nixosModules; [
      (modulesPath + "/virtualisation/digital-ocean-image.nix")

      server
    ];

    deploy.tags = [
      "vps"
    ];
  };

  flake.homeModules.doctl = { pkgs, ... }: {
    home.packages = with pkgs; [
      doctl
    ];

    home.persistence.home.directories = [
      ".config/doctl"
    ];
  };
}
