{ self, ... }:

{
  flake.nixosModules.server = {
    imports = with self.nixosModules; [
      base
      ssh-server
    ];

    security.pam.sshAgentAuth.enable = true;

    time.timeZone = "UTC";

    deploy.tags = [
      "server"
    ];

    documentation.nixos.enable = false;
  };
}
