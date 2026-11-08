{ self, ... }:

{
  flake.nixosModules.server = { lib, ... }: {
    imports = with self.nixosModules; [
      base
      ssh-server
    ];

    security.pam.sshAgentAuth.enable = true;

    time.timeZone = "UTC";

    services.netbird.useRoutingFeatures = "server";
    services.tailscale.useRoutingFeatures = lib.mkForce "none";

    deploy.tags = [
      "server"
    ];

    documentation.nixos.enable = false;
  };
}
