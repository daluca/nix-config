{ self, ... }:

{
  flake.nixosModules.server = {
    imports = with self.nixosModules; [
      base
    ];

    time.timeZone = "UTC";
  };
}
