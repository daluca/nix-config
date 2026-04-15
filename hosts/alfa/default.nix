{ lib, outputs, ... }@args:
let
  secrets = args.secrets // fromTOML (builtins.readFile ./secrets.toml);
in {
  imports = with outputs.nixosModules; [
    ./..
    ./disko.nix

    hetzner-cloud-x86
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "impermanence/grub"
    "remote-unlocking/dhcp"
    "tailscale/server"
    "atticd"
    "nginx"
  ];

  networking.localCommands = /* bash */ ''
    ip rule add to 10.2.1.0/24 priority 2500 lookup main || true
  '';

  services.tailscale.extraUpFlags = [
    "--advertise-routes=10.2.1.0/24"
  ];

  services.nginx.virtualHosts = {
    "attic.${secrets.domain.general}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
      };
      extraConfig = /* nginx */ ''
        client_max_body_size 1G;
      '';
    };
  };

  networking.hostName = "alfa";

  system.stateVersion = "25.11";
}
