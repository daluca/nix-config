{ self, inputs, withSystem, ... }:

{
  flake.overlays.netbird = final: prev:
    # TODO: Remove once NixOS 26.11 is released
    withSystem prev.stdenv.hostPlatform.system (
      { inputs', ... }: {
        netbird-combined = inputs'.nixpkgs-unstable.legacyPackages.netbird-combined.overrideAttrs (oldAttrs: {
          version = "0.82.0-unstable-2026-10-29";

          src = oldAttrs.src.override {
            tag = null;
            rev = "6f73711d3bb1a01692b13638fafd365714ff895c";
            hash = "sha256-9zKAMGmftuZXsHuL1atW3hTZpumnJ4iBYVS38OnSXn8=";
          };

          vendorHash = "sha256-rzHnfPjjv4fNHSE2qk6/5wCZ3BH0LrFvDDmNNU5Di0s=";
        });
      }
    );

  flake.nixosModules.netbird-client =
    {
      config,
      pkgs,
      secrets,
      ...
    }:
    {
      services.netbird = {
        enable = true;
        package = pkgs.unstable.netbird;
        clients.default = {
          config.ManagementURL = {
            Scheme = "https";
            Host = "netbird.${secrets.domains.general}:443";
          };
        };
      };

      networking.firewall.trustedInterfaces = [
        config.services.netbird.clients.default.interface
      ];

      environment.persistence.system.directories = [
        {
          directory = "/var/lib/netbird";
          mode = "0700";
        }
      ];
    };

  flake.nixosModules.netbird-server =
    {
      config,
      lib,
      pkgs,
      secrets,
      ...
    }:
    {
      # TODO: Remove once upgrading to NixOS 26.11
      disabledModules = [
        "services/networking/netbird/dashboard.nix"
      ];

      imports =
        with inputs;
        with self.nixosModules;
        [
          netbird-options
          (nixpkgs-unstable + "/nixos/modules/services/networking/netbird/dashboard.nix")
        ];

      services.netbird.server.dashboard = rec {
        enable = true;
        enableNginx = true;
        package = pkgs.unstable.netbird-dashboard;
        domain = "netbird.${secrets.domains.primary}";
        managementServer = "https://${domain}";
        settings = {
          AUTH_AUDIENCE = "netbird-dashboard";
          AUTH_CLIENT_ID = "netbird-dashboard";
          AUTH_AUTHORITY = "${managementServer}/oauth2";
          USE_AUTH0 = false;
          AUTH_SUPPORTED_SCOPES = "openid profile email groups";
          AUTH_REDIRECT_URI = "/nb-auth";
          AUTH_SILENT_REDIRECT_URI = "/nb-silent-auth";
          NGINX_SSL_PORT = toString 443;
          LETSENCRYPT_DOMAIN = "none";
        };
      };

      services.netbird.server.combined = {
        enable = true;
        stun.openFirewall = true;
        credentialsFile = config.sops.templates."netbird-secrets.env".path;
        settings = {
          exposedAddress = "https://netbird.${secrets.domains.primary}:443";
          disableAnonymousMetrics = true;
        };
      };

      sops.templates."netbird-secrets.env" = {
        restartUnits = [ "netbird-server.service" ];
        content = lib.generators.toKeyValue { } {
          NB_AUTH_SECRET = config.sops.placeholder."netbird/auth-secret";
          NB_STORE_ENCRYPTION_KEY = config.sops.placeholder."netbird/encryption-key";
          NB_IDP_SESSION_COOKIE_ENCRYPTION_KEY = config.sops.placeholder."netbird/session-key";
        };
      };

      sops.secrets."netbird/auth-secret" = { };

      sops.secrets."netbird/session-key" = { };

      sops.secrets."netbird/encryption-key" = { };

      services.nginx = {
        upstreams = {
          netbird_server = {
            servers = {
              ${config.services.netbird.server.combined.settings.listenAddress} = { };
            };
          };
        };
        virtualHosts."netbird.${secrets.domains.primary}" = {
          forceSSL = true;
          useACMEHost = secrets.domains.primary;
          root = config.services.netbird.server.dashboard.finalDrv;
          locations."~ ^/(relay|ws-proxy/)" = {
            proxyPass = "http://netbird_server";
            proxyWebsockets = true;
            recommendedProxySettings = false;
            extraConfig = /* nginx */ ''
              proxy_set_header Host $host;
              proxy_read_timeout 1d;
            '';
          };
          locations."~ ^/(signalexchange\\.SignalExchange|management\\.ManagementService)/" = {
            recommendedProxySettings = false;
            extraConfig = /* nginx */ ''
              grpc_pass grpc://netbird_server;
              grpc_read_timeout 1d;
              grpc_send_timeout 1d;
              grpc_socket_keepalive on;
            '';
          };
          locations."~ ^/(api|oauth2)/" = {
            proxyPass = "http://netbird_server";
            recommendedProxySettings = false;
            extraConfig = /* nginx */ ''
              proxy_set_header Host $host;
            '';
          };
          locations."/".recommendedProxySettings = false;
          extraConfig = /* nginx */ ''
            client_header_timeout 1d;
            client_body_timeout 1d;

            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Scheme $scheme;
            proxy_set_header X-Forwarded-Proto https;
            proxy_set_header X-Forwarded-Host $host;
            grpc_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
      };

      environment.persistence.system.directories = [
        {
          directory = "/var/lib/private/netbird-server";
          mode = "0700";
        }
      ];
    };

  flake.nixosModules.netbird-options =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.netbird.server.combined;

      configFile = pkgs.writeText "netbird-config.yaml" (builtins.toJSON (lib.recursiveUpdate
        {
          server = {
            inherit (cfg) dataDir;
            exposedAddress = cfg.settings.exposedAddress;
            stunPorts = cfg.stun.ports;
            metricsPort = 9090;
            healthcheckAddress = "127.0.0.1:9000";
            logLevel = "info";
            logFile = "console";
            auth = {
              issuer = "${cfg.settings.exposedAddress}/oauth2";
              signKeyRefreshEnabled = true;
              dashboardRedirectURIs = [
                "${lib.removeSuffix ":443" cfg.settings.exposedAddress}/nb-auth"
                "${lib.removeSuffix ":443" cfg.settings.exposedAddress}/nb-silent-auth"
              ];
              cliRedirectURIs = [
                "http://127.0.0.1:53000/"
              ];
            };
            reverseProxy.trustedHTTPProxies = [
              "127.0.0.1"
            ];
            store = {
              engine = "sqlite";
            };
          };
        }
        {
          server = cfg.settings;
        }
      ));
    in
    with lib;
    {
      options.services.netbird.server.combined = {
        enable = lib.mkEnableOption "netbird-combined";

        package = lib.mkPackageOption pkgs "netbird-combined" { };

        credentialsFile = lib.mkOption {
          type = types.nullOr types.externalPath;
          description = "Credentials file passed to systemd service.";
          default = null;
        };

        dataDir = lib.mkOption {
          type = types.str;
          description = "Netbird server data directory.";
          default = "/var/lib/netbird-server";
        };

        stun = lib.mkOption {
          type = types.submodule {
            options = {
              openFirewall = lib.mkEnableOption "Open firewall ports for STUN.";

              ports = lib.mkOption {
                type = types.listOf types.port;
                description = "List of STUN ports.";
                default = [ 3478 ];
              };
            };
          };
        };

        settings = lib.mkOption {
          type = types.submodule {
            freeformType = types.attrs;
            options = {
              listenAddress = lib.mkOption {
                type = types.str;
                default = "127.0.0.1:8081";
                description = "Address the netbird server listens to.";
              };

              exposedAddress = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "URL of the netbird with be accessible on.";
              };
            };
          };
        };
      };

      config = lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = cfg.settings.exposedAddress != null;
            message = "services.netbird.combined.settings.exposedAddress must be set for netbird combined server";
          }
        ];

        environment.systemPackages = [
          cfg.package
        ];

        systemd.services.netbird-server = {
          description = "NetBird combined server";
          documentation = [ "https://docs.netbird.io/selfhosted/selfhosted-quickstart" ];
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            ExecStart = "${lib.getExe cfg.package} --config ${configFile}";
            EnvironmentFile = lib.mkIf (cfg.credentialsFile != null) cfg.credentialsFile;

            DynamicUser = true;
            StateDirectory = "netbird-server";
            StateDirectoryMode = "0700";
            RuntimeDirectory = [ "netbird-server" ];
            RuntimeDirectoryMode = "0700";
            WorkingDirectory = cfg.dataDir;
            Restart = "on-failure";
            RestartSec = "5s";
            UMask = "0077";
            AmbientCapabilities = "";
            CapabilityBoundingSet = [ "" ] ++ lib.optionals ((toInt (lib.removePrefix "127.0.0.1:" cfg.settings.listenAddress)) < 1024) [ "CAP_NET_BIND_SERVICE" ];
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            ProcSubset = "pid";
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            RemoveIPC = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged @resources"
            ];
          };
        };

        networking.firewall.allowedUDPPorts = lib.optionals cfg.stun.openFirewall cfg.stun.ports;
      };
    };
}
