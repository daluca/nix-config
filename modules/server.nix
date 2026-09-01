{ self, ... }:

{
  flake.nixosModules.server = {
    imports = with self.nixosModules; [
      base
      ssh-server
    ];

    time.timeZone = "UTC";

    colmena.tags = [
      "server"
    ];
  };
}
