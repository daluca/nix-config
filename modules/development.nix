{ self, ... }:

{
  flake.homeManagerModules.development = { ... }: {
    imports = with self.homeManagerModules; [
      direnv
      gardenTools
      just
      opentofu
    ];

    home.persistence.home.directories = [
      "Projects"
    ];
  };
}
