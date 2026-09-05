{ self, inputs, ... }:
let
  secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
in
{
  flake.nixosConfigurations.bravo = inputs.nixos-raspberrypi.lib.nixosSystem {
    system = "aarch64-linux";
    modules = with self.nixosModules; [
      hosts-bravo
    ];
  };

  flake.nixosModules.hosts-bravo = { config, pkgs, ... }: {
    imports = with self.nixosModules; [
      hosts-bravo-disko

      hetzner-cloud-arm

      users-remotebuild

      remote-unlocking-dhcp
      impermanence-grub
      nginx
      ntfy-sh
      atuin
      miniflux
    ];

    sops.defaultSopsFile = ./bravo.sops.yaml;

    environment.etc."ssh/ssh_initrd_ed25519_key.pub".source = ./keys/ssh_initrd_ed25519_key.pub;

    environment.etc."ssh/ssh_initrd_rsa_key.pub".source = ./keys/ssh_initrd_rsa_key.pub;

    colmena.tags = [
      "germany"
    ];

    services.ntfy-sh.settings.base-url = "https://ntfy.${secrets.cloud.domain}";

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
      with config.services;
      {
        "ntfy.${secrets.domain.general}" = tls // {
          locations."/" = {
            proxyPass = "http://${ntfy-sh.settings.listen-http}/";
            proxyWebsockets = true;
          };
        };
        "atuin.${secrets.domain.general}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString atuin.port}/";
          };
        };
        "miniflux.${secrets.domain.general}" = tls // {
          locations."/" = {
            proxyPass = "http://${miniflux.config.LISTEN_ADDR}/";
          };
        };
        "nextflux.${secrets.domain.general}" = tls // {
          locations."/" = {
            root = "${pkgs.nextflux}/share/html";
            tryFiles = "$uri $uri/ index.html =403";
          };
        };
      };

    networking.hostName = "bravo";

    system.stateVersion = "26.05";
  };

  flake.nixosModules.hosts-bravo-sshKnownHosts = { config, ... }: {
    programs.ssh.knownHosts = rec {
      bravo = {
        extraHostNames = [
          "bravo.${config.networking.domain}"
          secrets.hosts.bravo.ipv4-address
        ];
        publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
      };
      "bravo/rsa" = {
        hostNames = [ "bravo" ] ++ bravo.extraHostNames;
        publicKeyFile = ./keys/ssh_host_rsa_key.pub;
      };
      bravo-initrd = {
        hostNames = [ "[bravo]:22022" ] ++ bravo-initrd.extraHostNames;
        extraHostNames = [
          "[bravo.${config.networking.domain}]:22022"
          "[${secrets.hosts.bravo.ipv4-address}]:22022"
        ];
        publicKeyFile = ./keys/ssh_initrd_ed25519_key.pub;
      };
      "bravo-initrd/rsa" = {
        hostNames = [ "[bravo]:22022" ] ++ bravo-initrd.extraHostNames;
        publicKeyFile = ./keys/ssh_initrd_rsa_key.pub;
      };
    };
  };

  flake.nixosModules.hosts-bravo-cache = {
    nix.settings.trusted-public-keys = [
      "bravo:2zk2IqImbGCABS9Ly1akZZ8P9xq8MkzCXFmdAlH23h0="
    ];
  };
}
