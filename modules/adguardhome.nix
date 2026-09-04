{ self, ... }:
let
  secrets = fromTOML (builtins.readFile ../secrets/secrets.toml);
in
{
  flake.overlays.adguardhome = _final: prev: {
    # NOTE: DNS rewrites do not work in the 26.05 or unstable
    # The last check version that did not work was v0.107.77
    # https://github.com/AdguardTeam/AdGuardHome/issues/7602
    adguardhome = prev.adguardhome.overrideAttrs (oldAttrs: rec {
      version = "0.107.65";

      src = oldAttrs.src.override {
        tag = "v${version}";
        hash = "sha256-OOW77CJRR5vi5jHFOCyF/OyCXaQdTgEc8xZKPcF9vQE=";
      };

      vendorHash = "sha256-spBMVSZhiM0R5tf8dhZD+N4ucFZ9Wno9Y+BhZMdzQRM=";

      dashboard = prev.buildNpmPackage {
        inherit src version;
        pname = "adguardhome-dashboard";
        postPatch = ''
          cd client
        '';
        npmDepsHash = "sha256-s7TJvGyk05HkAOgjYmozvIQ3l2zYUhWrGRJrWdp9ZJQ=";
        npmBuildScript = "build-prod";
        postBuild = ''
          mkdir -p $out/build/
          cp -r ../build/static/ $out/build/
        '';
      };

      passthru = oldAttrs.passthru // {
        schema_version = 30;
      };
    });
  };

  flake.nixosModules.adguardhome =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.adguardhome = {
        enable = true;
        mutableSettings = false;
        settings = {
          dns = {
            bind_hosts = [
              "127.0.0.1"
            ];
            upstream_dns = [
              "127.0.0.1:5353"
            ];
            bootstrap_dns = [
              "9.9.9.9"
              "149.112.112.112"
            ];
          };
          filters = [
            {
              enabled = true;
              url = "https://big.oisd.nl/";
              name = "oisd big";
              id = 1;
            }
          ];
        };
      };

      services.unbound = {
        enable = true;
        package = pkgs.unbound-full;
        resolveLocalQueries = false;
        settings = {
          server = {
            interface = [ "127.0.0.1@5353" ];
            verbosity = 2;
            module-config = "\"${
              lib.concatStringsSep " " [
                "validator"
                "cachedb"
                "iterator"
              ]
            }\"";
          };
          remote-control.control-enable = true;
          cachedb = {
            backend = "redis";
            redis-server-path = config.services.redis.servers.unbound.unixSocket;
          };
        };
      };

      services.redis.servers.unbound = with config.services; {
        enable = true;
        user = unbound.user;
        group = unbound.group;
      };

      networking.firewall = {
        allowedUDPPorts = [ 53 ];
      };
    };

  flake.nixosModules.adguardhome-netherlands = { config, lib, ... }: {
    imports = with self.nixosModules; [
      adguardhome
    ];

    services.adguardhome = {
      port = 80;
      openFirewall = true;
      settings = {
        dns = {
          bind_hosts = [ "10.1.1.10" ];
          upstream_dns = [
            "[//in-addr.arpa/ip6.arpa/${config.networking.domain}/]10.1.1.1"
            "[/${secrets.parents.domain}/]192.168.10.10"
            "[/${
              lib.concatStringsSep "/" [
                "jellyfin.${secrets.parents.domain}"
                "request.${secrets.parents.domain}"
                "requests.${secrets.parents.domain}"
                "jellyfin.${secrets.domain.general}"
                "request.${secrets.domain.general}"
                "requests.${secrets.domain.general}"
              ]
            }/]#"
          ];
          fallback_dns = [
            "9.9.9.9"
            "149.112.112.112"
          ];
          hostsfile_enabled = false;
          local_ptr_upstreams = [
            "10.1.1.1"
          ];
        };
        filtering.rewrites =
          let
            dalaran = subdomain: {
              domain = "${subdomain}.${secrets.domain.general}";
              answer = "10.1.1.11";
            };
            shodan = subdomain: {
              domain = "${subdomain}.${secrets.domain.general}";
              answer = secrets.hosts.shodan.tailscale-address;
            };
            internalHost = hostName: answer: {
              inherit answer;
              domain = "${hostName}.${config.networking.domain}";
            };
            externalHost = hostName: {
              domain = "${hostName}.${config.networking.domain}";
              answer = secrets.hosts.${hostName}.ipv4-address;
            };
          in
          [
            (internalHost "stormwind" "10.1.1.10")
            (internalHost "ironforge" "192.168.10.10")
            (internalHost "guiltyspark" "192.168.10.20")
            (internalHost "darnassus" "192.168.1.212")
            (externalHost "alfa")
            (externalHost "bravo")
            (externalHost "charlie")
            (externalHost "delta")
            (externalHost "unifi")
            (externalHost "shodan")
            (dalaran "paperless")
            (dalaran "redlib")
            (dalaran "adguardhome")
            (dalaran "navidrome")
            (dalaran "share")
            (dalaran "gatus")
            (dalaran "firefly")
            (dalaran "firefly-importer")
            (dalaran "home-assistant")
            (dalaran "zigbee2mqtt")
            (dalaran "unifi")
            (shodan "sonarr")
            (shodan "radarr")
            (shodan "prowlarr")
            (shodan "sabnzbd")
            (shodan "qbittorrent")
          ];
      };
    };
  };

  flake.nixosModules.adguardhome-dalaran = { config, lib, ... }: {
    imports = with self.nixosModules; [
      adguardhome-netherlands
    ];

    services.adguardhome = {
      port = lib.mkForce 3000;
      openFirewall = lib.mkForce true;
      settings = {
        dns = {
          bind_hosts = lib.mkForce [
            "10.1.1.11"
            "127.0.0.1"
          ];
        };
        filtering.rewrites = [
          {
            domain = "dalaran.${config.networking.domain}";
            answer = "10.1.1.11";
          }
        ];
      };
    };
  };
}
