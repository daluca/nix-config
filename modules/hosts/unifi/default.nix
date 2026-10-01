{ self, inputs, ... }:

{
  flake.nixosConfigurations.unifi =
    let
      secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
    in
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit secrets; };
      modules = with self.nixosModules; [
        unifi
      ];
    };

  flake.nixosModules.unifi = { config, secrets, ... }: {
    imports = with self.nixosModules; [
      digitalocean
      unifi-controller
      nginx
    ];

    sops.defaultSopsFile = ./unifi.sops.yaml;

    deploy.tags = [
      "australia"
    ];

    deploy.ipv4-address = secrets.hosts.unifi.ipv4-address;

    networking.hostName = "unifi";

    networking.enableIPv6 = false;

    security.acme.certs.${secrets.domain.general}.domain = "*.${secrets.domain.general}";

    services.nginx.virtualHosts =
      let
        cert = config.security.acme.certs.${secrets.domain.general};
        sslCertificate = "${cert.directory}/fullchain.pem";
        sslCertificateKey = "${cert.directory}/key.pem";
        sslTrustedCertificate = "${cert.directory}/chain.pem";
        tls = {
          inherit sslCertificate sslCertificateKey sslTrustedCertificate;
          forceSSL = true;
        };
      in
      {
        "unifi.${secrets.parents.domain}" = tls // {
          locations."/" = {
            proxyPass = "https://127.0.0.1:8443";
          };
          locations."/wss/" = {
            proxyPass = "https://127.0.0.1:8443";
            proxyWebsockets = true;
            extraConfig = /* nginx */ ''
              proxy_ssl_verify off;
            '';
          };
        };
      };

    system.stateVersion = "26.05";
  };

  flake.nixosModules.unifi-sshKnownHosts = { config, secrets, ... }: {
    programs.ssh.knownHosts = rec {
      unifi = {
        extraHostNames = [
          "unifi.${config.networking.domain}"
          secrets.hosts.unifi.ipv4-address
        ];
        publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
      };
      "unifi/rsa" = {
        hostNames = [ "unifi" ] ++ unifi.extraHostNames;
        publicKeyFile = ./keys/ssh_host_rsa_key.pub;
      };
    };
  };
}
