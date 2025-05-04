{ config, lib, secrets, inputs, ... }:
let
  cert = config.security.acme.certs.${secrets.parents.domain};
in {
  # TODO: Remove when updated to 25.05
  # https://github.com/NixOS/nixpkgs/issues/370118
  # Workaround is to import unstable module
  disabledModules = [ "services/monitoring/cockpit.nix" ];

  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/monitoring/cockpit.nix"
  ];

  services.cockpit = {
    enable = true;
    openFirewall = true;
    settings = {
      WebService = {
        AllowUnencrypted = true;
        ProtocolHeader = "X-Forwarded-Proto";
        Origins = lib.mkForce (lib.concatStringsSep " " [
          "http://127.0.0.1:${builtins.toString config.services.cockpit.port}"
          "http://guiltyspark:${builtins.toString config.services.cockpit.port}"
          "https://cockpit.${secrets.parents.domain}"
        ]);
      };
    };
  };

  services.nginx.virtualHosts = {
    "cockpit.${secrets.parents.domain}" = {
      forceSSL = true;
      sslCertificate = "${cert.directory}/fullchain.pem";
      sslCertificateKey = "${cert.directory}/key.pem";
      sslTrustedCertificate = "${cert.directory}/chain.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:9090";
        proxyWebsockets = true;
        extraConfig = /* nginx */ ''
          gzip off;
        '';
      };
    };
  };
}
