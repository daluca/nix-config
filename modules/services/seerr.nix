{
  flake.overlays.seerr-unstable = _final: prev: {
    seerr = prev.seerr.overrideAttrs (oldAttrs: rec {
      version = "preview-new-oidc";

      src = oldAttrs.src.override {
        tag = version;
        hash = "sha256-VZN6C02nVuF6tunTLQhDYF+nYS99jZlP/uywXRdkwZ4=";
      };

      pnpmDeps = prev.fetchPnpmDeps {
        inherit (oldAttrs) pname;
        inherit version src;
        pnpm = prev.pnpm_10.override { nodejs-slim = prev.nodejs-slim_22; };
        fetcherVersion = 3;
        hash = "sha256-gqjz0DM0VYdFKTkoKPG9fjAwZlKeQZS1GB4wwUcwZ9M=";
      };
    });
  };

  flake.nixosModules.seerr = { pkgs, ... }: {
    services.seerr = {
      enable = true;
      package = pkgs.unstable.seerr;
      configDir = "/var/lib/seerr/config";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/private 0700 - - -"
    ];

    environment.persistence.system.directories = [
      {
        directory = "/var/lib/private/seerr";
        mode = "0700";
        defaultPerms.mode = "0700";
      }
    ];
  };
}
