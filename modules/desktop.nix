{ self, ... }:

{
  flake.nixosModules.desktop = {
    imports = with self.nixosModules; [
      base
      kanata
    ];

    time.timeZone = "Europe/Amsterdam";

    nix.settings = {
      warn-dirty = false;
      trusted-public-keys = [
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      ];
    };

    colmena.tags = [
      "desktop"
    ];

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
