{ self, ... }:

{
  flake.nixosModules.server = {
    imports = with self.nixosModules; [
      base
      ssh-server
    ];

    time.timeZone = "UTC";

    deploy.tags = [
      "server"
    ];
  };
}
