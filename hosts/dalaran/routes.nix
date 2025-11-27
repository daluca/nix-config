{ config, secrets }:
let
  cert = config.security.acme.certs.${secrets.domain.general};
  sslCertificate = "${cert.directory}/fullchain.pem";
  sslCertificateKey = "${cert.directory}/key.pem";
  sslTrustedCertificate = "${cert.directory}/chain.pem";
  tls = {
    inherit sslCertificate sslCertificateKey sslTrustedCertificate;
    forceSSL = true;
  };
in with config.services; {
  "paperless.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString paperless.port}";
    };
  };

  "redlib.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString redlib.port}";
    };
  };

  "navidrome.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString navidrome.settings.Port}";
    };
  };

  "request.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString jellyseerr.port}";
    };
  };

  "jellyfin.${secrets.domain.general}" = tls // {
    extraConfig = /* nginx */ ''
      client_max_body_size 20M;
      add_header X-Content-Type-Options "nosniff";
      add_header Permissions-Policy "accelerometer=(), ambient-light-sensor=(), battery=(), bluetooth=(), camera=(), clipboard-read=(), display-capture=(), document-domain=(), encrypted-media=(), gamepad=(), geolocation=(), gyroscope=(), hid=(), idle-detection=(), interest-cohort=(), keyboard-map=(), local-fonts=(), magnetometer=(), microphone=(), payment=(), publickey-credentials-get=(), serial=(), sync-xhr=(), usb=(), xr-spatial-tracking=()" always;
      add_header Content-Security-Policy "default-src https: data: blob: ; img-src 'self' https://* ; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline' https://www.gstatic.com https://www.youtube.com blob:; worker-src 'self' blob:; connect-src 'self'; object-src 'none'; frame-ancestors 'self'; font-src 'self'";
    '';
    locations = let
      jellyfin = "http://127.0.0.1:8096";
    in {
      "/" = {
        proxyPass = jellyfin;
        extraConfig = /* nginx */ ''
          proxy_buffering off;
        '';
      };
      "/socket" = {
        proxyPass = jellyfin;
        proxyWebsockets = true;
      };
    };
  };

  "sonarr.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString sonarr.settings.server.port}";
    };
  };

  "radarr.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString radarr.settings.server.port}";
    };
  };

  "prowlarr.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString prowlarr.settings.server.port}";
    };
  };

  "sabnzbd.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
    };
  };


  ${firefly-iii.virtualHost} = tls;

  ${firefly-iii-data-importer.virtualHost} = tls;
}
