{ self, ... }:

{
  flake.nixosModules.desktop = {
    imports = with self.nixosModules; [
      base
    ];

    time.timeZone = "Europe/Amsterdam";

    nix.settings = {
      warn-dirty = false;
      substituters = [
        "https://nixos-raspberrypi.cachix.org?priority=100"
      ];
      trusted-public-keys = [
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      ];
    };

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
