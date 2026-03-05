{ lib, ... }@args:
let
  secrets = args.secrets // fromTOML (builtins.readFile ./secrets.toml);
in {
  imports = [
    ./..
    ./disko.nix
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/hetzner/cloud/x86"
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "impermanence/grub"
    "remote-unlocking/dhcp"
    "tailscale/server"
    "atticd"
    "nginx"
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
